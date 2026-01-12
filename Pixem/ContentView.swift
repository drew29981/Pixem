//
//  ContentView.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @Query private var jobs: [Job]

    var body: some View {
        Navigation()
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
