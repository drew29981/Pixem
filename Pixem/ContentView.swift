//
//  ContentView.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject private var router: Router
    
    @Environment(\.modelContext) private var modelContext
    @Query private var jobs: [Job]

//    @State private var currentJobs: [Job] = [Job(id: UUID(), started: Date.now, title: "", expectedHours: Int.random(in: 30...100), actualHours: Int.random(in: 30...100), workers: ["Drew", "Saba", "Moosie"], isComplete: Bool.random()),
//        
//        Job(id: UUID(), started: Date.now, title: "", expectedHours: Int.random(in: 30...100), actualHours: Int.random(in: 30...100), workers: ["Toon", "Saba"], isComplete: Bool.random()),
//                                             
//        Job(id: UUID(), started: Date.now, title: "", expectedHours: Int.random(in: 30...100), actualHours: Int.random(in: 30...100), workers: ["Saba"], isComplete: Bool.random())]
//    
//    let newJob = Job(id: UUID(), started: Date.now, title: "", expectedHours: 32, actualHours: 40, workers: ["Drew", "Toon", "Moosie"], isComplete: false)
    
//    func makeUIView(context: Context) -> UIToolbar {
//        let toolbar = UIToolbar()
//        // configure toolbar
//        return toolbar
//    }
//    
//    func updateUIView(_ uiView: UIToolbar, context: Context) {
//        // update if needed
//        
//    }

    var body: some View {
        NavigationSplitView {
//            Menu("Actions") {
//                Button("Duplicate", action: {})
//                Button("Rename", action: {})
//                Button("Delete…", action: {})
//                Menu("Copy") {
//                    Button("Copy", action: {})
//                    Button("Copy Formatted", action: {})
//                    Button("Copy Library Path", action: {})
//                }
//            }
            TabView {
                Card()
                
                if jobs.isEmpty {
                    Button(action: {
                        router.push(.createJob)
                    }) {
                        Text("Create your first job!")
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
//                    currentJobs.append(newJob)
            }

        } detail: {
            Text("Select an item")
        }
    }
}

extension View {
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            hidden()
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Job.self, inMemory: true)
}
