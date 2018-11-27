//
//  TestSummarySubGroup.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestSummarySubGroup {
    
    let testName: String
    let tests: [Test]
    
}

extension TestSummarySubGroup: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case tests = "Subtests"
    }
    
}
