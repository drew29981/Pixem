//
//  Home.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct Home: View {
    var body: some View {
        VStack {
            Text("Welcome to the home page!")
                .bold()
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("Home")
            }
        }
    }
}
