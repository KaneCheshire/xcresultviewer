//
//  TestSummarySubGroup.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestSummarySubGroup: Codable {
    let testName: String
    let tests: [Test]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case tests = "Subtests"
    }
}
