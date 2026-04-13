//
//  Job.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import Foundation
import SwiftData

public enum JobStatus: String, Codable, CaseIterable {
    case draft, active, paused, complete, archived
}

@Model
public final class Job {
    public var id: UUID
    public var title: String
    public var createdAt: Date
    public var startedAt: Date?
    public var completedAt: Date?
    public var status: JobStatus

    /// What the client pays for the job. Drives profit math.
    public var quotedPrice: Double?

    /// Optional job-level hour budget. When nil, the expected total is derived
    /// from the sum of each worker's `expectedHours` (per-worker pricing mode).
    /// When set, this is the authoritative total (lump-sum pricing mode).
    public var estimatedHours: Double?

    @Relationship(deleteRule: .cascade)
    public var workers: [Worker] = []

    @Relationship(deleteRule: .cascade, inverse: \ShiftEntry.job)
    public var shifts: [ShiftEntry] = []

    public init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = .now,
        startedAt: Date? = nil,
        completedAt: Date? = nil,
        status: JobStatus = .draft,
        quotedPrice: Double? = nil,
        estimatedHours: Double? = nil,
        workers: [Worker] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.status = status
        self.quotedPrice = quotedPrice
        self.estimatedHours = estimatedHours
        self.workers = workers
    }

    // MARK: - Derived hours

    public var expectedHoursTotal: Double {
        estimatedHours ?? workers.reduce(0) { $0 + $1.expectedHours }
    }

    public var actualHoursTotal: Double {
        workers.reduce(0) { $0 + $1.actualHours }
    }

    // MARK: - Derived cost

    public var expectedLaborCost: Double {
        workers.reduce(0) { $0 + $1.expectedCost }
    }

    public var actualLaborCost: Double {
        workers.reduce(0) { $0 + $1.actualCost }
    }

    public var expectedProfit: Double? {
        quotedPrice.map { $0 - expectedLaborCost }
    }

    public var actualProfit: Double? {
        quotedPrice.map { $0 - actualLaborCost }
    }

    // MARK: - Money-at-risk signals

    /// 0..1+ ratio of actual to expected labor cost. >1 means over budget.
    public var budgetBurn: Double {
        guard expectedLaborCost > 0 else { return 0 }
        return actualLaborCost / expectedLaborCost
    }

    public var isOverBudget: Bool {
        status != .complete && budgetBurn > 1
    }

    public var isOverHours: Bool {
        let target = expectedHoursTotal
        return status != .complete && target > 0 && actualHoursTotal > target
    }

    /// True when the job has crossed a meaningful threshold that should draw
    /// the user's attention. Kept as the single "needs attention" flag.
    public var autoFlag: Bool { isOverBudget || isOverHours }

    public var isActive: Bool {
        workers.contains { $0.isClockedIn }
    }
}
