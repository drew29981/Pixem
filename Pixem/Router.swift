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
}
