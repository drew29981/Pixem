//
//  CreateJob.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftUI
import SwiftData

/// How the user priced this job for the client.
/// Determines which fields the form asks for; the underlying cost model is the same.
private enum PricingMode: String, CaseIterable, Identifiable {
    case perWorker   = "Per worker"
    case lumpSum     = "Lump sum"
    var id: String { rawValue }
}

struct CreateJob: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var description: String = ""
    @State private var workers: [Worker] = []
    @State private var workersEarnDifferent: Bool = true
    @State private var sameHourlyPay: Double?
    @State private var quotedPrice: Double?
    @State private var lumpSumHours: Double?
    @State private var pricingMode: PricingMode = .perWorker
    @State private var startJob: Bool = false
    @State private var notify: Bool = false

    private var totalExpectedHours: Double {
        switch pricingMode {
        case .perWorker: return workers.reduce(0) { $0 + $1.expectedHours }
        case .lumpSum:   return lumpSumHours ?? 0
        }
    }

    private var totalLaborCost: Double {
        if !workersEarnDifferent {
            return (sameHourlyPay ?? 0) * totalExpectedHours
        }
        switch pricingMode {
        case .perWorker:
            return workers.reduce(0) { $0 + $1.hourlyRate * $1.expectedHours }
        case .lumpSum:
            // Distribute lump-sum hours evenly across workers for cost estimate.
            guard !workers.isEmpty else { return 0 }
            let avgRate = workers.reduce(0) { $0 + $1.hourlyRate } / Double(workers.count)
            return avgRate * totalExpectedHours
        }
    }

    public var formInvalid: Bool {
        workers.isEmpty ||
        description.isEmpty ||
        workers.contains(where: \.name.isEmpty)
    }

    var body: some View {
        Form {
            Section(header: Text("Job Info")) {
                HStack {
                    TextField("Description", text: $description, prompt: Text("Description"))
                    Text("\(notify ? " (Required)" : "")")
                        .foregroundStyle(Color.red)
                        .hidden(!notify)
                }
                Toggle("Activate Job", isOn: $startJob)
                Toggle("Workers Earn Different", isOn: $workersEarnDifferent)
                Picker("Pricing", selection: $pricingMode) {
                    ForEach(PricingMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Workers") {
                Stepper("", value: workerCountBinding, in: 0...50)
                ForEach(0..<workers.count, id: \.self) { i in
                    HStack {
                        TextField("Full Name", text: $workers[i].name)
                        TextField("Pay Rate", value: $workers[i].hourlyRate, format: .number)
                            .hidden(!workersEarnDifferent)
                            .keyboardType(.decimalPad)
                        if pricingMode == .perWorker {
                            TextField("Hours", value: $workers[i].expectedHours, format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                .onDelete(perform: deleteWorkers)

                if !workers.isEmpty {
                    HStack {
                        TextField("Pay Rate", value: $sameHourlyPay, format: .number)
                            .hidden(workersEarnDifferent)
                            .keyboardType(.decimalPad)
                        Text("Total labor: \(totalLaborCost.formatted(.currency(code: "USD")))")
                    }
                }
            }

            Section("Job Details") {
                if pricingMode == .lumpSum {
                    TextField("Total Estimated Hours", value: $lumpSumHours, format: .number)
                        .keyboardType(.decimalPad)
                }
                TextField("Quoted Price (what the client pays)",
                          value: $quotedPrice,
                          format: .number)
                    .keyboardType(.decimalPad)
                if let quoted = quotedPrice {
                    let projectedProfit = quoted - totalLaborCost
                    Text("Projected profit: \(projectedProfit.formatted(.currency(code: "USD")))")
                        .foregroundStyle(projectedProfit < 0 ? Color.red : Color.green)
                }
            }

            if notify {
                Text("Check all required fields.")
                    .bold()
                    .foregroundStyle(Color.red)
            }

            Section {
                Button("Submit") {
                    let allowedApostrophes: Set<Character> = ["'", "\u{2019}"]
                    let inputChecksFail = description.contains { s in
                        let isAllowed = s.isLetter || s.isNumber || s.isWhitespace || allowedApostrophes.contains(s)
                        return !isAllowed || description.count < 5
                    }
                    if inputChecksFail {
                        formAlert()
                        return
                    }
                    submit()
                    dismiss()
                }
                .disabled(formInvalid)
            }
        }
        .onChange(of: notify) { _, _ in formAlert() }
    }

    private func deleteWorkers(offsets: IndexSet) {
        withAnimation { workers.remove(atOffsets: offsets) }
    }

    private var workerCountBinding: Binding<Int> {
        Binding<Int>(
            get: { workers.count },
            set: { newCount in
                let diff = newCount - workers.count
                if diff > 0 {
                    for _ in 0..<diff { workers.append(Worker()) }
                } else if diff < 0 {
                    for _ in 0..<(-diff) { workers.removeLast() }
                }
            }
        )
    }

    private func formAlert() {
        notify = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            notify = false
        }
    }

    private func submit() {
        // If the user chose a flat rate, apply it to each worker so cost math stays consistent.
        if !workersEarnDifferent, let flat = sameHourlyPay {
            for w in workers { w.hourlyRate = flat }
        }

        // For lump-sum pricing, distribute total hours evenly as each worker's expected hours.
        if pricingMode == .lumpSum, let total = lumpSumHours, !workers.isEmpty {
            let perWorker = total / Double(workers.count)
            for w in workers { w.expectedHours = perWorker }
        }

        let now = Date.now
        let newJob = Job(
            title: description,
            createdAt: now,
            startedAt: startJob ? now : nil,
            status: startJob ? .active : .draft,
            quotedPrice: quotedPrice,
            estimatedHours: pricingMode == .lumpSum ? lumpSumHours : nil,
            workers: workers
        )

        modelContext.insert(newJob)
        do {
            try modelContext.save()
        } catch {
            print(error)
        }
    }
}

#Preview {
    CreateJob()
}
