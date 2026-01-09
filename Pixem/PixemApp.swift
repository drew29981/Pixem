//
//  PixemApp.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

@main
struct PixemApp: App {
    @StateObject var router: Router = Router()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Job.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Navigation(navigationTitle: "") {
                ContentView()
            }
            .environmentObject(router)
        }
        .modelContainer(sharedModelContainer)
    }
}
