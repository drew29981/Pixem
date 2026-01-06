//
//  ContentView.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let PI = 3.14159265358979323846
    @State private var clicked: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    let msg = "\(PI, default: "%.2f")"
                    Button(action: {
                        clicked.toggle()
                        
                    }) {
                        Text("Print PI")
                    }
                    .alert(isPresented: $clicked) {
                        Alert(title: Text("\(msg.self)"))
                        
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    let msg = "O'MAMA"
                    Button(action: {
                        clicked.toggle()
                        
                    }) {
                        Text("O'MAMA")
                    }
                    .alert(isPresented: $clicked) {
                        Alert(title: Text("\(msg.self)"))
                        
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
