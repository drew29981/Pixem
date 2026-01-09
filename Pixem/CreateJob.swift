//
//  CreateJob.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftUI
import SwiftData

struct CreateJob: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var jobs: [Job]
    
    @State private var workers: [Worker] = []
    @State private var startJob: Bool = false
    @State private var workersEarnDifferent: Bool = true
    @State private var sameHourlyPay: Double?
    @State private var description: String = ""
    @State private var expectedProfit: Double?
    @State private var calculatedCosts: Double?
    @State private var calculatedHours: Int?
    @State private var estimatedCompletion: Int?
    
    @State private var notify: Bool = false
    
    public var autoFlag: Bool { workers.count <= 0 || description.isEmpty || workers.contains(where: \.name.isEmpty) }
    
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
            }
            Section("Workers") {
                Stepper("", value: getAsBindingInt(), in: 0...50)
                ForEach(0..<workers.count, id: \.self) { i in
                    HStack {
                        TextField("Full Name", text: $workers[i].name)
                        TextField("Pay Rate", value: $workers[i].hourlyRate, format: .number)
                            .hidden(!workersEarnDifferent)
                            .keyboardType(.decimalPad)
                            .onChange(of: workers[i].hourlyRate) { oldValue, newValue in
                                
                                // if the new value is not a number
                                // workers[i].hourlyRate = oldValue
                            }
                        TextField("Expected Hours", value: $workers[i].expectedHours, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
                .onDelete(perform: deleteWorkers)
                
                if workers.count > 0  {
                    HStack {
                        TextField("Pay Rate", value: $sameHourlyPay, format: .number)
                            .hidden(workersEarnDifferent)
                            .keyboardType(.decimalPad)
                        
                        let totalHours = workers.reduce(0) { $0 + Int($1.expectedHours ?? 0) }
                        let costs: Double = !workersEarnDifferent ? (sameHourlyPay ?? 0) * Double(totalHours) : workers.reduce(0.0) { $0 + (Double($1.hourlyRate ?? 0.0) * Double($1.expectedHours ?? 0)) }
                        
                        Text("Total labor costs: \(costs)")
                            .hidden(workers.count <= 0)
                            .onChange(of: costs) {
                                calculatedCosts = costs
                                calculatedHours = totalHours
                            }
                    }
                }
            }
            
            Section("Job Details") {
                TextField("Estimated Completion", value: $estimatedCompletion, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            if notify {
                Text("Check all required fields.")
                    .bold()
                    .foregroundStyle(Color.red)
            }
            Section {
                Button("Submit") {
                    let allowedApostrophes: Set<Character> = ["'", "’"]

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
                .disabled(autoFlag)
            }
        }
        .onChange(of: notify) { oldValue, newValue in
            formAlert()
        }
    }
    private func deleteWorkers(offsets: IndexSet) {
        withAnimation {
            workers.remove(atOffsets: offsets)
        }
    }
    private func getAsBindingInt() -> Binding<Int> {
        let newVal = Binding<Int>(
            get: {
                self.workers.count
            },
            set: { newCount in
                let diff = newCount - self.workers.count
                if diff > 0 {
                    for _ in 0..<diff {
                        workers.append(Worker())
                    }
                } else if (diff < 0) {
                    for _ in 0..<(-diff) {
                        workers.removeLast()
                    }
                }
            }
        )
        return newVal
    }
    private func formAlert() {
        notify = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            notify = false
        }
    }
    private func submit() {
        let newJob = Job(id: UUID(), started: Date.now, title: description, workers: workers, isComplete: false, expectedProfit: expectedProfit ?? 0, totalWorkerCost: Double(calculatedCosts ?? 0), hoursToComplete: estimatedCompletion ?? 0)
        
        modelContext.insert(newJob)
        
        do {
            try modelContext.save()
        }
        catch {
            print(error)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(jobs[index])
            }
        }
    }
}

#Preview {
    CreateJob()
}
