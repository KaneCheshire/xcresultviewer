//
//  Result+Helpers.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

typealias TestLevel = (Int, Result.TestableSummary.Test)
typealias ActivityLevels = (Int, Result.TestableSummary.Test.ActivitySummary)

extension Result.TestableSummary.Test {
    
    func allTests(from levelIndex: Int) -> [TestLevel] {
        var allTests: [TestLevel] = [(levelIndex, self)]
        if let subtests = Subtests {
            allTests.append(contentsOf: subtests.flatMap { $0.allTests(from: levelIndex + 1) })
        }
        return allTests
    }
    
}

extension Result.TestableSummary.Test.ActivitySummary {
    
    func allSummaries(from levelIndex: Int) -> [ActivityLevels] {
        var allSummaries: [ActivityLevels] = [(levelIndex, self)]
        if let subActivities = SubActivities {
            allSummaries.append(contentsOf: subActivities.flatMap { $0.allSummaries(from: levelIndex + 1) })
        }
        return allSummaries
    }
    
}
