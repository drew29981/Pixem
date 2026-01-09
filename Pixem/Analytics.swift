//
//  Analytics.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct Analytics: View {
    let PI = 3.14159265358979323846
    @State private var clicked: Bool = false
    @State private var fontSize = 12.0
    @State private var text = "Hello World"

    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Text("Welcome to the analytics page!")
                .bold()
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("Analytics")
            }
        }
    }
}

#Preview {
    Analytics()
        .modelContainer(for: Job.self, inMemory: true)
}
