//
//  Test.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Test {
    
    let name: String
    let activitySummaries: [ActivitySummary]
    let failureSummaries: [FailureSummary]?
    let duration: TimeInterval
    
}

extension Test: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "TestName"
        case activitySummaries = "ActivitySummaries"
        case failureSummaries = "FailureSummaries"
        case duration = "Duration"
    }
    
}
