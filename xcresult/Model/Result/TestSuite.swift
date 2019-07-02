//
//  TestSuite.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestSuite {
    
    let name: String
    let subTestSuites: [SubTestSuite]
    
}

extension TestSuite: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "TestName"
        case subTestSuites = "Subtests"
    }
    
}
