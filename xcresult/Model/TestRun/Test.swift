//
//  Test.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestCase {
    
    let name: String
    let tests: [Test]
    let duration: TimeInterval
    
    var containsFailures: Bool {
        return tests.first(where: { $0.failureSummaries != nil }) != nil
    }
}

extension TestCase: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "TestName"
        case tests = "Subtests"
        case duration = "Duration"
    }
    
}
