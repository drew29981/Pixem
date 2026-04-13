//
//  Worker.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import Foundation
import SwiftData

@Model
public final class Worker {
    public var id: UUID
    public var name: String
    public var hourlyRate: Double
    public var expectedHours: Double

    @Relationship(deleteRule: .cascade, inverse: \ShiftEntry.worker)
    public var shifts: [ShiftEntry] = []

    public init(
        id: UUID = UUID(),
        name: String = "",
        hourlyRate: Double = 0,
        expectedHours: Double = 0
    ) {
        self.id = id
        self.name = name
        self.hourlyRate = hourlyRate
        self.expectedHours = expectedHours
    }

    public var actualHours: Double {
        shifts.reduce(0) { $0 + $1.duration }
    }

    public var expectedCost: Double { hourlyRate * expectedHours }
    public var actualCost:   Double { hourlyRate * actualHours }

    public var isClockedIn: Bool {
        shifts.contains { $0.isActive }
    }
}
