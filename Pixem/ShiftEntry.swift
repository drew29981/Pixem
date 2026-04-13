//
//  ShiftEntry.swift
//  Pixem
//
//  Records a single clock-in/out interval for a worker on a job.
//  `end == nil` means the worker is still clocked in.
//

import Foundation
import SwiftData

@Model
public final class ShiftEntry {
    public var id: UUID
    public var start: Date
    public var end: Date?
    public var worker: Worker?
    public var job: Job?

    public init(
        id: UUID = UUID(),
        start: Date = .now,
        end: Date? = nil,
        worker: Worker? = nil,
        job: Job? = nil
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.worker = worker
        self.job = job
    }

    /// Duration in hours. Uses `Date.now` as the endpoint while the shift is active.
    public var duration: Double {
        let stop = end ?? .now
        return max(0, stop.timeIntervalSince(start) / 3600)
    }

    public var isActive: Bool { end == nil }
}
