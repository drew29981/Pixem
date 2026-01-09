//
//  Jobs.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct Jobs: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var jobs: [Job]
    
    @EnvironmentObject var router: Router
    
    @State private var columnVisibility =
    NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List {
                ForEach(jobs) { job in
                    Button(action: {
                        router.push(.job(job))
                    }) {
                        Text("\(job.title)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .largeTitle) {
                    Text("Jobs")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        router.push(.createJob)
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
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
    Jobs()
        .modelContainer(for: Job.self, inMemory: true)
}
