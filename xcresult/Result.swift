//
//  Result.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 19/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

struct Result: Codable {
    let testableSummaries: [TestableSummary]
    
    enum CodingKeys: String, CodingKey {
        case testableSummaries = "TestableSummaries"
    }
}

struct TestableSummary: Codable {
    let testName: String
    let testSummaryGroups: [TestSummaryGroup]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case testSummaryGroups = "Tests"
    }
}

struct TestSummaryGroup: Codable {
    let testName: String
    let testSummarySubGroups: [TestSummarySubGroup]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case testSummarySubGroups = "Subtests"
    }
}

struct TestSummarySubGroup: Codable {
    let testName: String
    let tests: [Test]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case tests = "Subtests"
    }
}

struct Test: Codable {
    let testName: String
    let subtests: [SubTest]
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case subtests = "Subtests"
    }
    
    var containsFailures: Bool {
        return subtests.first(where: { $0.failureSummaries != nil }) != nil
    }
}

struct SubTest: Codable {
    let testName: String
    let activitySummaries: [ActivitySummary]
    let failureSummaries: [FailureSummary]?
    
    enum CodingKeys: String, CodingKey {
        case testName = "TestName"
        case activitySummaries = "ActivitySummaries"
        case failureSummaries = "FailureSummaries"
    }
}

struct FailureSummary: Codable {
    
}

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
    
    enum CodingKeys: String, CodingKey {
        case subActivities = "SubActivities"
        case attachments = "Attachments"
        case uuid = "UUID"
        case title = "Title"
        case startTimeInterval = "StartTimeInterval"
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
}

struct Attachment: Codable {
    let filename: String
    
    enum CodingKeys: String, CodingKey {
        case filename = "Filename"
    }
}
