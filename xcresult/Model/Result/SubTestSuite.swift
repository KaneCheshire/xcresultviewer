//
//  SubTestSuite.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct SubTestSuite {
    
    let name: String
    let testCases: [TestCase]
    
}

extension SubTestSuite: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "TestName"
        case testCases = "Subtests"
    }
    
}
