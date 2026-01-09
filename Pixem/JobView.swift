//
//  JobView.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import SwiftUI
import SwiftData

struct JobView: View {
    @State private var job: Job
    
    init(job: Job) {
        self.job = job
    }
    
    @ViewBuilder var body: some View {
        List {
            Text("\(job.title)")
                .bold()
            Text("Date Started: \(job.started)")
            Text("Actual: \(Double(job.actualCost!)) vs Expected Cost: \(Double(job.expectedCost!))")
            VStack(alignment: .listRowSeparatorLeading) {
                Text("Total Worker Cost: \(Double(job.totalWorkerCost ?? 0.0))")
                Text("Total Worker Hours: \(job.workers.reduce(0.0) { $0 + Double($1.expectedHours ?? 0) })")
                
                Text("Workers: \(job.workers.enumerated().map(\.element.name).joined(separator: ", "))")
            }
            Text("Completed?: \(job.isComplete ? "Yes" : "No")")
        }
    }
}
