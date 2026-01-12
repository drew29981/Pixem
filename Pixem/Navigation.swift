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

struct Navigation: View {
    @EnvironmentObject private var router: Router
    
    @ViewBuilder var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack(path: $router.path) {
                    Home()
                        .navigationDestination(for: Destination.self) { destination in
                            destination.view
                        }
                }
            }
            Tab("Jobs", systemImage: "suitcase.fill") {
                NavigationStack(path: $router.path) {
                    Jobs()
                        .navigationDestination(for: Destination.self) { destination in
                            destination.view
                        }
                }
            }
            Tab("You", systemImage: "person.and.background.dotted") {
                NavigationStack(path: $router.path) {
                    You()
                        .navigationDestination(for: Destination.self) { destination in
                            destination.view
                        }
                }
            }
        }
        .tabViewStyle(.tabBarOnly)
//            .searchable(text: $text, placement: .toolbar) // creates a search bar (useful for future additions)
    }
}

#Preview {
    Navigation()
}
