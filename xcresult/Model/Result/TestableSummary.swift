//
//  TestableSummary.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestableSummary: Codable {
    let testName: String
    let testSummaryGroups: [TestSummaryGroup]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case testSummaryGroups = "Tests"
    }
}
