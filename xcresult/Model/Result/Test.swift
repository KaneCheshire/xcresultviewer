//
//  Test.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Test: Codable {
    let testName: String
    let subtests: [SubTest]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case subtests = "Subtests"
    }
    
    var containsFailures: Bool {
        return subtests.first(where: { $0.failureSummaries != nil }) != nil
    }
}
