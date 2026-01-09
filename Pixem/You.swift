//
//  You.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftData
import SwiftUI

struct You: View {
    var body: some View {
        VStack {
            Text("Welcome to your profile!")
                .bold()
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("You")
            }
        }
    }
}
