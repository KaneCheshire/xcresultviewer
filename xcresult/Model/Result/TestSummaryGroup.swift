//
//  TestSummaryGroup.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestSummaryGroup {
    
    let testName: String
    let testSummarySubGroups: [TestSummarySubGroup]
    
}

extension TestSummaryGroup: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case testSummarySubGroups = "Subtests"
    }
    
}
