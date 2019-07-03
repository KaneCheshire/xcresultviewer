//
//  TestRun.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 19/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct TestRun {
    
    let testTargets: [TestTarget]
    
}

extension TestRun: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testTargets = "TestableSummaries"
    }
    
}

