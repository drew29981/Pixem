//
//  JobView.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import SwiftUI
import SwiftData

struct JobView: View {
    @Bindable var job: Job
    @AppStorage("currencyCode") private var currencyCode: String = Locale.current.currency?.identifier ?? "AUD"

    private var currency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: currencyCode)
    }

    @ViewBuilder var body: some View {
        List {
            Section {
                Text(job.title).bold().font(.title2)
                HStack {
                    Text("Status")
                    Spacer()
                    Text(job.status.rawValue.capitalized)
                        .foregroundStyle(job.autoFlag ? Color.red : Color.secondary)
                }
                if let started = job.startedAt {
                    Text("Started: \(started.formatted(date: .abbreviated, time: .shortened))")
                } else {
                    Text("Not yet started")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Money") {
                if let quoted = job.quotedPrice {
                    row("Quoted price", quoted.formatted(currency))
                }
                row("Expected labor", job.expectedLaborCost.formatted(currency))
                row("Actual labor",   job.actualLaborCost.formatted(currency),
                    tint: job.isOverBudget ? .red : nil)
                if let profit = job.expectedProfit {
                    row("Expected profit", profit.formatted(currency),
                        tint: profit < 0 ? .red : .green)
                }
                if let profit = job.actualProfit {
                    row("Actual profit", profit.formatted(currency),
                        tint: profit < 0 ? .red : .green)
                }
                row("Budget burn",
                    "\(Int(job.budgetBurn * 100))%",
                    tint: job.isOverBudget ? .red : nil)
            }

            Section("Hours") {
                row("Expected", String(format: "%.1f h", job.expectedHoursTotal))
                row("Actual",   String(format: "%.1f h", job.actualHoursTotal),
                    tint: job.isOverHours ? .red : nil)
            }

            Section("Workers") {
                ForEach(job.workers) { worker in
                    VStack(alignment: .leading) {
                        Text(worker.name).bold()
                        Text("\(worker.hourlyRate.formatted(currency))/hr · \(String(format: "%.1f", worker.actualHours))/\(String(format: "%.1f", worker.expectedHours)) h")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func row(_ label: String, _ value: String, tint: Color? = nil) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundStyle(tint ?? .primary)
        }
    }
}
