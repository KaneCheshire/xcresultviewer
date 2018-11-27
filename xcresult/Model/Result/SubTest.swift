//
//  SubTest.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct SubTest {
    
    let testName: String
    let activitySummaries: [ActivitySummary]
    let failureSummaries: [FailureSummary]?
    
}

extension SubTest: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case activitySummaries = "ActivitySummaries"
        case failureSummaries = "FailureSummaries"
    }
    
}
