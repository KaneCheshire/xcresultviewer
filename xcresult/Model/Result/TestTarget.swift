//
//  TestTarget.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestTarget {
    
    let name: String
    let testSuites: [TestSuite]
    
}

extension TestTarget: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "TestName"
        case testSuites = "Tests"
    }
    
}
