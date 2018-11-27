//
//  Result.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 19/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Result {
    
    let testableSummaries: [TestableSummary]
    
}

extension Result: Codable {
    
    enum CodingKeys: String, CodingKey {
        case testableSummaries = "TestableSummaries"
    }
    
}

