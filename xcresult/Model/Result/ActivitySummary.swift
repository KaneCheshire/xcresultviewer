//
//  ActivitySummary.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 27/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct ActivitySummary: Codable {
    
    typealias ActivityLevel = (activity: ActivitySummary, level: Int)
    
    enum ActivityType: String, Codable {
        case userCreated = "com.apple.dt.xctest.activity-type.userCreated"
        case attachmentContainer = "com.apple.dt.xctest.activity-type.attachmentContainer"
        case assertionFailure = "com.apple.dt.xctest.activity-type.testAssertionFailure"
        case appleInternal = "com.apple.dt.xctest.activity-type.internal"
        case deletedAttachment = "com.apple.dt.xctest.activity-type.deletedAttachment"
    }
    
    let activityType: ActivityType
    let subActivities: [ActivitySummary]?
    let attachments: [Attachment]?
    let uuid: UUID
    let title: String
    let startTimeInterval: TimeInterval
    let finishTimeInterval: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case subActivities = "SubActivities"
        case attachments = "Attachments"
        case uuid = "UUID"
        case title = "Title"
        case startTimeInterval = "StartTimeInterval"
        case finishTimeInterval = "FinishTimeInterval"
        case activityType = "ActivityType"
    }
    
    func allSummaryLevels(from level: Int = 0) -> [ActivityLevel] {
        var allSummaries = [(self, level)]
        if let subActivities = subActivities {
            allSummaries.append(contentsOf: subActivities.flatMap { $0.allSummaryLevels(from: level + 1) })
        }
        return allSummaries
    }
    
    var containsAttachment: Bool {
        return allSummaryLevels().first(where: { $0.activity.attachments != nil }) != nil
    }
    
    var duration: TimeInterval {
        return Double(Int((finishTimeInterval - startTimeInterval) * 100)) / 100
    }
}
