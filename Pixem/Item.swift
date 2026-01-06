//
//  Item.swift
//  Pixem
//
//  Created by Andrew Younan on 6/1/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
