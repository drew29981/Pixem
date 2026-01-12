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
    
    @EnvironmentObject private var router: Router
    
//    @State private var columnVisibility =
//    NavigationSplitViewVisibility.doubleColumn
//    (columnVisibility: $columnVisibility)
    var body: some View {
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
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .title) {
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

/*
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
 .safeAreaInset(edge: .top, content: {
     HStack(alignment: .center) {
         EditButton()
             .buttonStyle(.glass)
         
         Button(action: {
             router.push(.createJob)
         }) {
             Image(systemName: "plus")
         }
         .buttonStyle(.glassProminent)
     }
 })
 .toolbar {
     ToolbarItem(placement: .largeTitle) {
         Text("Jobs")
     }
     
 }
 */
