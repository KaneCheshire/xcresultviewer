//
//  Result.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 19/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Result: Codable {
    
    let TestableSummaries: [TestableSummary]
    
    struct TestableSummary: Codable {
        let TestKind: String
        let Tests: [Test]
        
        struct Test: Codable {
            let Duration: TimeInterval
            let TestName: String
            let TestIdentifier: String
            let Subtests: [Test]?
            let ActivitySummaries: [ActivitySummary]?
            
            struct ActivitySummary: Codable {
                let ActivityType: ActivityType
                let SubActivities: [ActivitySummary]?
                let Attachments: [Attachment]?
                let StartTimeInterval: TimeInterval
                let FinishTimeInterval: TimeInterval
                let UUID: UUID
                let Title: String
                
                enum ActivityType: Codable {
                    case general
                    case attachmentContainer
                    case assertionFailure
                    
                    init(from decoder: Decoder) throws {
                        let container = try decoder.singleValueContainer()
                        let value = try container.decode(String.self)
                        switch value {
                        case "com.apple.dt.xctest.activity-type.testAssertionFailure": self = .assertionFailure
                        case "com.apple.dt.xctest.activity-type.attachmentContainer": self = .attachmentContainer
                        default: self = .general
                        }
                    }
                    
                    func encode(to encoder: Encoder) throws {
                        fatalError()
                    }
                }
                
                struct Attachment: Codable {
                    let Filename: String
                }
            }
        }
    }
}


