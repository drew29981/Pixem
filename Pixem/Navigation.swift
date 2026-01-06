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
    
    @Binding public var animateNavBar: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .listRowSeparatorLeading, spacing: 20) {
                NavigationLink(destination: Home()) {
                    Image(systemName: "house.fill")
                    Text("Home")
                        .bold()
                }
                .offset(x: 20)
                NavigationLink(destination: Analytics()) {
                    Image(systemName: "chart.bar.yaxis")
                    Text("Analytics")
                        .bold()
                    //                                chart.line.uptrend.xyaxis
                }
                .offset(x: 40)
                NavigationLink(destination: Jobs()) {
                    Image(systemName: "suitcase.fill")
                    Text("Jobs")
                        .bold()
                }
                .offset(x: 60)
                NavigationLink(destination: Analytics()) {
                    Image(systemName: "person.and.background.dotted")
                        .imageScale(.large)
                    Text("You")
                        .bold()
                    //                                    profile
                }
                .offset(x: 80)
            }
            .animation(.bouncy.speed(0.5), value: animateNavBar)
        }
    }
}
