//
//  Analyzer.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 02/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

struct Analyzer {
    
    func analyze(result: Result) {
        let then = Date()
        let totalDuration = result.totalTestDuration()
        print("Total duration of \(Int(totalDuration)) seconds/\(Int(totalDuration / 60)) minutes from \(result.testCount()) test functions in \(result.allTestCases().count) test cases")
        print("Average test function duration of \(Int(result.averageTestDuration())) seconds")
        print("\n-------\n")
        let longestFunctions = result.longestTestCase().tests.count
        print("Longest test case was \(result.longestTestCase().name) at \(Int(result.longestTestCase().duration)) seconds and with \(longestFunctions) test \(longestFunctions == 1 ? "function" : "functions")")
        let shortestFunctions = result.shortestTestCase().tests.count
        print("Shortest test case was \(result.shortestTestCase().name) at \(Int(result.shortestTestCase().duration)) seconds and with \(shortestFunctions) test \(shortestFunctions == 1 ? "function" : "functions ")")
        print("\n-------\n")
        print("Longest test function was \(result.longestTest().name) at \(Int(result.longestTest().duration)) seconds")
        print("Shortest test function was \(result.shortestTest().name) at \(Int(result.shortestTest().duration)) seconds")
        print("\n-------\n")
        print("The following test cases have more than one test function and should be split up to take full advantage of parallel tests:\(testCasesWithMoreThanOneTestFunctionString(from: result))")
        print("\n-------\n")
        print("Analyzing took \(Date().timeIntervalSince(then)) seconds\n\n")
    }
    
    private func testCasesWithMoreThanOneTestFunctionString(from result: Result) -> String {
        return result.testCasesWithMoreThanOneTest().sorted(by: { $0.duration > $1.duration }).reduce(into: "", { result, testCase in
            result += "\n\(testCase.name) (\(testCase.tests.count) tests, \(Int(testCase.duration)) seconds)"
        })
    }
    
}

private extension Result {
    
    func allTestCases() -> [TestCase] {
        return testTargets
            .flatMap { $0.testSuites }
            .flatMap { $0.subTestSuites }
            .flatMap { $0.testCases }
    }
    
    func allTests() -> [Test] {
        return allTestCases()
            .flatMap { $0.tests }
    }
    
    func testCount() -> Int {
        return allTests().count
    }
    
    func totalTestDuration() -> TimeInterval {
        let durations = allTests().map { $0.duration }
        return durations.reduce(0.0, +)
    }
    
    func averageTestDuration() -> TimeInterval {
        let durations = allTests().map { $0.duration }
        let totalDuration = totalTestDuration()
        return totalDuration > 0 ? totalDuration / Double(durations.count) : 0
    }
    
    func longestTest() -> Test {
        let tests = allTests()
        return tests.reduce(tests.first!) { $0.duration >= $1.duration ? $0 : $1 }
    }
    
    func longestTestCase() -> TestCase {
        let testCases = allTestCases()
        return allTestCases().reduce(testCases.first!, { $0.duration >= $1.duration ? $0 : $1 })
    }
    
    func shortestTest() -> Test {
        let tests = allTests()
        return tests.reduce(tests.first!) { $0.duration < $1.duration ? $0 : $1 }
    }
    
    func shortestTestCase() -> TestCase {
        let testCases = allTestCases()
        return allTestCases().reduce(testCases.first!, { $0.duration < $1.duration ? $0 : $1 })
    }
    
    func testCasesWithMoreThanOneTest() -> [TestCase] {
        let testCases = allTestCases()
        return testCases.filter { $0.tests.count > 1 }
    }
    
}
