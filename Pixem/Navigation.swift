//
//  Navigation.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftUI
import SwiftData

/* Programmatic Navigation (Without Links)
 
    If you need to navigate based on logic (e.g., after a button tap or async operation), use a navigation path:
 
    @State private var path = NavigationPath()  // Manages the stack programmatically
 
 */

struct Navigation<Content: View>: View {
    
    @EnvironmentObject private var router: Router
    @State private var navigationTitle: String
    @State public var content: Content
    
    init(navigationTitle: String, @ViewBuilder content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.content = content()
    }
    
    @ViewBuilder var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                content
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        router.path.append(.home)
                    }) {
                        Image(systemName: "house.fill")
                        Text("Home")
                            .bold()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        router.path.append(.jobs)
                    }) {
                        Image(systemName: "suitcase.fill")
                        Text("Jobs")
                            .bold()
                    }
    //                NavigationLink(destination: Jobs()) {
    //                    Image(systemName: "suitcase.fill")
    //                    Text("Jobs")
    //                        .bold()
    //                }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        router.path.append(.you)
                    }) {
                        Image(systemName: "person.and.background.dotted")
                        Text("You")
                            .bold()
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .you:
                    You()
                case .home:
                    Home()
                case .jobs:
                    Jobs()
                case .job(let job):
                    JobView(job: job)
                case .createJob:
                    CreateJob()
                case .analytics:
                    EmptyView()
                }
            }
//            .searchable(text: $text, placement: .toolbar) // creates a search bar (useful for future additions)
        }
    }
}
