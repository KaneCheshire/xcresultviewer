//
//  TestableSummary.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestableSummary {
    
    let testName: String
    let testSummaryGroups: [TestSummaryGroup]
    
}

extension TestableSummary: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case testSummaryGroups = "Tests"
    }
    
}
