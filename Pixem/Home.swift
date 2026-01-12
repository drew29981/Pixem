//
//  Home.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import SwiftUI
import SwiftData

struct Home: View {
    @EnvironmentObject private var router: Router
    @Query var jobs: [Job]
    
    var body: some View {
        TabView {
            Card()
            
            if jobs.isEmpty {
                Button(action: {
                    router.push(.createJob)
                }) {
                    Text("Create your first job!")
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        }
    }
}
