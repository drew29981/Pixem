//
//  Worker.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import Foundation
import SwiftData

@Model
public class Worker {
    public var name: String
    public var hourlyRate: Double?
    public var actualHours: Int?
    public var expectedHours: Int?
    
    init(name: String, hourlyRate: Double, actualHours: Int?, expectedHours: Int?) {
        self.name = name
        self.hourlyRate = hourlyRate
        self.actualHours = actualHours
    }
    init() {
        name = ""
    }
}
