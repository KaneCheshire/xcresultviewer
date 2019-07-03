//
//  XCResultViewer.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 03/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

struct XCResultViewer {
    
    init(arguments: [String] = ProcessInfo.processInfo.arguments) throws {
        if let resultArgument = ProcessInfo.processInfo.arguments[safeAt: 1] {
            let url = URL(fileURLWithPath: resultArgument)
            guard url.isXCResult else { fatalError("Provided path is not to an xcresult") }
            url.testRuns().forEach { testRun in
                let failurePageGenerator = FailurePageGenerator(testRun: testRun, xcresultURL: url)
                failurePageGenerator.generate()
                let analyzer = Analyzer(testRun: testRun)
                analyzer.analyze()
            }
        } else {
            print("Missing path to xcresult")
        }
    }
    
}
