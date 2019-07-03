//
//  XCResultViewer.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 03/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

struct XCResultViewer {
    
    init(arguments: [String] = ProcessInfo.processInfo.arguments) {
        guard let path = ProcessInfo.processInfo.arguments.last else { fatalError("Missing path to xcresult") }
        let url = URL(fileURLWithPath: path)
        guard url.isXCResult else { fatalError("Missing path to xcresult") }
        let flags: [Flag] = arguments.compactMap { Flag(rawValue: $0) }
        url.testRuns().forEach { testRun in
            if flags.contains(.analyze) {
                let analyzer = Analyzer(testRun: testRun)
                analyzer.analyze()
            } else {
                let failurePageGenerator = FailurePageGenerator(testRun: testRun, xcresultURL: url)
                failurePageGenerator.generate(shouldOpenBrowser: !flags.contains(.skipOpenBrowser))
            }
        }
    }
    
}

private extension XCResultViewer {
    
    enum Flag {
        
        case analyze
        case skipOpenBrowser
        
        init?(rawValue: String) {
            switch rawValue {
            case "-a", "--analyze": self = .analyze
            case "-s", "--skip-open-browser": self = .skipOpenBrowser
            default: return nil
            }
        }
        
    }
    
}
