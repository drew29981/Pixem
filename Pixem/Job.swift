//
//  Job.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import Foundation
import SwiftData

@Model
public class Job {
    public var id: UUID
    public var started: Date
    public var title: String
    public var workers: [Worker]
    public var totalWorkerCost: Double? = 0
    public var isComplete: Bool
    public var hoursToComplete: Int? = 0
    public var totalHoursElasped: Int? = 0
    public var autoFlag: Bool {
        workers.first { w in
            (w.actualHours ?? 0 > w.expectedHours ?? 0 && !isComplete) || (w.actualHours ?? 0 >  0 && expectedCost ?? 0 > actualCost ?? 0)
        } != nil
    }
    public var expectedCost: Double? = 0
    public var actualCost: Double? = 0
    public var expectedProfit: Double? = 0
    
    init(id: UUID, started: Date, title: String, workers: [Worker], isComplete: Bool, expectedCost: Double? = 0, actualCost: Double? = 0, expectedProfit: Double? = 0, totalWorkerCost: Double? = 0, hoursToComplete: Int?) {
        self.id = id
        self.started = started
        self.title = title
        self.workers = workers
        self.isComplete = isComplete
        self.expectedCost = expectedCost
        self.actualCost = actualCost
        self.expectedProfit = expectedProfit
        self.totalWorkerCost = totalWorkerCost
    }
    
    init(job: Job) {
        self.id = job.id
        self.started = job.started
        self.title = job.title
        self.workers = job.workers
        self.isComplete = job.isComplete
        self.expectedCost = job.expectedCost
        self.actualCost = job.actualCost
        self.expectedProfit = job.expectedProfit
        self.totalWorkerCost = job.totalWorkerCost
        self.hoursToComplete = job.hoursToComplete
    }
}
