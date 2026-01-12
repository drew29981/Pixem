//
//  Destination.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import SwiftUI

enum Destination: Hashable {
    case home
    case job(Job)
    case jobs
    case createJob
    case analytics
    case you
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .you:
            You()
        case .home:
            Home()
        case .job(let job):
            JobView(job: job)
        case .jobs:
            Jobs()
        case .createJob:
            CreateJob()
        case .analytics:
            EmptyView()
        }
    }
}
