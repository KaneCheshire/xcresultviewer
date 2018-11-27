//
//  Attachment.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Attachment: Codable {
    let filename: String
    
    enum CodingKeys: String, CodingKey {
        case filename = "Filename"
    }
}
