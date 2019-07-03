//
//  Result+Helpers.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 03/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

extension TestRun {
    
    // Returns all test suites in the result as one flat array.
    func allTestSuites() -> [TestSuite] {
        return testTargets
            .flatMap { $0.testSuites }
    }
    
    /// Returns all test cases in the result as one flat array.
    func allTestCases() -> [TestCase] {
        return allTestSuites()
            .flatMap { $0.subTestSuites }
            .flatMap { $0.testCases }
    }
    
    /// Returns all test functions in the result as one flat array.
    func allTests() -> [Test] {
        return allTestCases()
            .flatMap { $0.tests }
    }

    /// Calculates the total duration of all test suites.
    func totalDuration() -> TimeInterval {
        let durations = allTestSuites().map { $0.duration }
        return durations.reduce(0.0, +)
    }
    
    /// Calculates the average test function duration.
    func averageTestDuration() -> TimeInterval {
        let durations = allTests().map { $0.duration }
        let total = durations.reduce(0.0, +)
        return total > 0 ? total / Double(durations.count) : 0
    }
    
    /// Determines the longest test function, if any
    func longestTest() -> Test? {
        let tests = allTests()
        guard let first = tests.first else { return nil }
        return tests.reduce(first) { $0.duration >= $1.duration ? $0 : $1 }
    }
    
    /// Determines the longest test case, if any
    func longestTestCase() -> TestCase? {
        let testCases = allTestCases()
        guard let first = testCases.first else { return nil }
        return allTestCases().reduce(first, { $0.duration >= $1.duration ? $0 : $1 })
    }
    
    /// Determines the shortest test function, if any
    func shortestTest() -> Test? {
        let tests = allTests()
        guard let first = tests.first else { return nil }
        return tests.reduce(first) { $0.duration < $1.duration ? $0 : $1 }
    }
    
    /// Determines the shortest test case, if any
    func shortestTestCase() -> TestCase? {
        let testCases = allTestCases()
        guard let first = testCases.first else { return nil }
        return allTestCases().reduce(first, { $0.duration < $1.duration ? $0 : $1 })
    }
    
    /// Returns the test cases with more than one test (may be empty if no test cases exist with more than one test)
    func testCasesWithMoreThanOneTest() -> [TestCase] {
        let testCases = allTestCases()
        return testCases.filter { $0.tests.count > 1 }
    }
    
}
