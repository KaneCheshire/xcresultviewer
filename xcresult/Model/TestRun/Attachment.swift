//
//  Attachment.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Attachment {
    
    let filename: String
    
}

extension Attachment: Codable {
    
    enum CodingKeys: String, CodingKey {
        case filename = "Filename"
    }
    
}
