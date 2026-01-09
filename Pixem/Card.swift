//
//  Card.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftUI
import SwiftData

struct Card: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: Router
    @Query private var jobs: [Job]
    
    @ViewBuilder var body: some View {
        ForEach(0..<jobs.count, id: \.self) { i in
            Button(action: {
                router.push(.job(jobs[i]))
            }) {
                VStack(alignment: .leading) {
                    Text("\(jobs[i].title)").bold()
                        .frame(width: 180)
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chart.bar.yaxis")
                        Text("Analyse")
                            .bold()
                            .frame(width: 80)
                    }
                    .buttonStyle(GlassButtonStyle())
                    .foregroundStyle(LinearGradient(
                        colors: [Color.black.opacity(0.8), Color.blue.opacity(0.5)],
                        startPoint: .leading, endPoint: .trailing))
                    
                    DisclosureGroup("") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text("\(jobs[i].workers.enumerated().map(\.element.name).joined(separator: ", "))")
                        }
                        VStack(alignment: .listRowSeparatorLeading) {
                            Label("\(jobs[i].expectedCost, default: "unspecified")", systemImage: "dollarsign")
                                .bold()
                                .foregroundStyle(Color.green)
                            Label("\(jobs[i].hoursToComplete, default: "unspecified")", systemImage: "hourglass")
                                .bold()
                            Label("\(jobs[i].workers.count, default: "unspecified")", systemImage: "person.3")
                                .bold()
                        }
                    }
                }
                .frame(alignment: .leading)
                .padding(50)
                .background(Color.clear.glassEffect())
            }
        }
        .frame(width: 300, height: 200)
        //        .buttonStyle(GlassButtonStyle())
    }
}

#Preview {
    Card().modelContainer(for: Job.self, inMemory: true)
}
