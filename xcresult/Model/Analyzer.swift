//
//  Analyzer.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 02/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

/// Analyzes a test run.
struct Analyzer {
    
    let testRun: TestRun
    
    /// Analyzes the result to help figure out how to optimize your tests for parallel testing.
    func analyze(_ start: Date = Date()) {
        analyzeTotalDuration()
        analyzeAverageDuration()
        print("\n-------\n")
        analyzeLongestTestCase()
        analyzeShortestTestCase()
        print("\n-------\n")
        analyzeLongestTestFunction()
        analyzeShortestTestFunction()
        print("\n-------\n")
        analyzeTestCasesWithMoreThanOneTestFunction()
        print("\n-------\n")
        calculateAnalyzeTime(from: start)
    }
    
    private func analyzeTotalDuration() {
        let totalDuration = testRun.totalDuration()
        print("Total duration of \(Int(totalDuration)) seconds/\(Int(totalDuration / 60)) minutes from \(testRun.allTests().count) test functions in \(testRun.allTestCases().count) test cases")
    }
    
    private func analyzeAverageDuration() {
        let averageDuration = Int(testRun.averageTestDuration())
        print("Average test function duration of \(averageDuration) seconds")
    }
    
    private func analyzeLongestTestCase() {
        if let longest = testRun.longestTestCase() {
            let testCount = longest.tests.count
            print("Longest test case was \(longest.name) at \(Int(longest.duration)) seconds and with \(testCount) test \(testCount == 1 ? "function" : "functions")")
        } else {
            print("Couldn't determine longest test case")
        }
    }
    
    private func analyzeShortestTestCase() {
        if let shortest = testRun.shortestTestCase() {
            let testCount = shortest.tests.count
            print("Shortest test case was \(shortest.name) at \(Int(shortest.duration)) seconds and with \(testCount) test \(testCount == 1 ? "function" : "functions ")")
        } else {
            print("Couldn't determine shortest test case")
        }
    }
    
    private func analyzeLongestTestFunction() {
        if let longest = testRun.longestTest() {
            print("Longest test function was \(longest.name) at \(Int(longest.duration)) seconds")
        } else {
            print("Couldn't determine longest test function")
        }
    }
    
    private func analyzeShortestTestFunction() {
        if let shortest = testRun.shortestTest() {
            print("Shortest test function was \(shortest.name) at \(Int(shortest.duration)) seconds")
        } else {
            print("Couldn't determine shortest test function")
        }
    }
    
    private func analyzeTestCasesWithMoreThanOneTestFunction() {
        let cases = testRun.testCasesWithMoreThanOneTest()
        if cases.isEmpty {
            print("No test cases with more than one test function found, optimum for parallel UI testing 👌")
        } else {
            let value = cases.sorted(by: { $0.duration > $1.duration }).reduce(into: "The following test cases have more than one test function and should be split up to take full advantage of parallel tests:", { result, testCase in
                result += "\n\(testCase.name) (\(testCase.tests.count) tests, \(Int(testCase.duration)) seconds)"
            })
            print(value)
        }
        
    }
    
    private func calculateAnalyzeTime(from start: Date) {
        print("Analyzing took \(Date().timeIntervalSince(start)) seconds\n\n")
    }
    
}
