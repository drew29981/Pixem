//
//  Router.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import Combine

final class Router: ObservableObject {
    @Published var path: [Destination] = []
}

extension Router {
    func push(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func reset() {
        path = []
    }
    
//    func last() -> String? {
//        let name = switch path.last {
//        case .home:
//            "Home"
//        case .analytics:
//            "Analytics"
//        case .createJob:
//            "CreateJob"
//        case .job:
//            "Job"
//        case .you:
//            "You"
//        case .none:
//            "None"
//        }
//        return name
//    }
}
