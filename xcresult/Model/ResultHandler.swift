//
//  ResultHandler.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import AppKit

struct ResultHandler {
    
    private var html = ""
    
    mutating func handle(resultURL url: URL) {
        guard url.pathExtension == "xcresult" else {
            return print("Provided path is not to an xcresult")
        }
        guard let summariesEnumerator = FileManager.default.enumerator(atPath: url.path) else {
            return print("Unable to create summaries enumerator")
        }
        let summariesPaths: [String] = summariesEnumerator.compactMap { thing in
            guard let path = thing as? String, path.contains("action_TestSummaries") else { return nil }
            return path
        }
        summariesPaths.forEach { summaryPath in
            let data = try? Data(contentsOf: url.appendingPathComponent(summaryPath))
            guard let result = try? PropertyListDecoder().decode(Result.self, from: data ?? Data()) else {
                return print("Unable to decode Result object")
            }
            handle(res: result, xcresultURL: url)
        }
    }
    
    private mutating func handle(res: Result, xcresultURL: URL) {
        appendBegginingHTML()
        res.testableSummaries.forEach { testableSummary in
            handle(testableSummary: testableSummary)
        }
        html += "</div></body></html>"
        let fileURL = xcresultURL.appendingPathComponent("xcresult.html")
        let htmlData = Data(html.utf8)
        do {
            try htmlData.write(to: fileURL)
            NSWorkspace.shared.open(fileURL)
        } catch {
            print("Unable to write html to url", fileURL, error.localizedDescription)
        }
    }
    
    private mutating func appendBegginingHTML() {
        html = """
        <html><head>
                <meta charset="utf-8">
                <style>
                body, html {
                    padding:0;
                    margin:0;
                    background:black;
                    color:white;
                    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                    font-weight: bold;
                }
                p {
                    padding:0; margin:0;
                }
                .wrapper {
                    width: 100%;
                    overflow-y: hidden;
                    white-space: nowrap;
                    vertical-align: top;
                }
                section {
                    white-space: nowrap;
                    display:inline-block;
                    vertical-align:top;
                    margin:8pt;
                    padding:16pt;
                    border-radius:6pt;
                    background:rgb(10, 10, 10);
                }
                section section {
                    padding:0;
                    margin:8pt 0 0 8pt;
                }
                section > p {
                    padding:0 0 8pt;
                }
                div.summary {
                    display:inline-block;
                    vertical-align: top;
                    border-radius:5pt;
                }
                div.summary p {
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    padding:8pt 0;
                    max-width:640pt;
                }
                img.screenshot {
                    border-radius:20pt;
                }
                p.user-activity {
                    background:rgb(42, 42, 42);
                    border-radius:5pt;
                    padding-left:8pt !important;
                }
            </style>
        </head><body><div class='wrapper'>
        """
    }
    
    private mutating func handle(testableSummary: TestableSummary) {
        html += "<section><p>\(testableSummary.testName)</p>"
        testableSummary.testSummaryGroups.forEach { testSummaryGroup in
            handle(testSummaryGroup: testSummaryGroup)
        }
        html += "</section>"
    }
    
    private mutating func handle(testSummaryGroup: TestSummaryGroup) {
        html += "<section><p>\(testSummaryGroup.testName)</p>"
        testSummaryGroup.testSummarySubGroups.forEach { testSummarySubGroup in
            handle(testSummarySubGroup: testSummarySubGroup)
        }
        html += "</section>"
    }
    
    private mutating func handle(testSummarySubGroup: TestSummarySubGroup) {
        html += "<section><p>\(testSummarySubGroup.testName)</p>"
        testSummarySubGroup.tests.forEach { test in
            handle(test: test)
        }
        html += "</section>"
    }
    
    private mutating func handle(test: Test) {
        guard test.containsFailures else { return }
        html += "<section><p>\(test.testName)</p>"
        test.subtests.forEach { subtest in
            handle(subtest: subtest)
        }
        html += "</section>"
    }
    
    private mutating func handle(subtest: SubTest) {
        guard subtest.failureSummaries != nil else { return }
        html += "<section><p>\(subtest.testName)</p><div class='summary'>"
        subtest.activitySummaries.forEach { activitySummary in
            handle(activitySummary: activitySummary)
        }
        html += "</div></section>"
    }
    
    private mutating func handle(activitySummary: ActivitySummary) {
        let allSummaryLevels = activitySummary.allSummaryLevels()
        let displayableSummaries = allSummaryLevels.filter { activitySummaryLevel in
            guard !activitySummaryLevel.activity.title.contains("snapshot accessibility hierarchy") else { return false }
            return activitySummaryLevel.activity.containsAttachment
        }
        displayableSummaries.forEach { activitySummaryLevel in
            let indent = String(repeating: "&nbsp;&nbsp;", count: activitySummaryLevel.level)
            let cssClass = activitySummaryLevel.activity.activityType == .userCreated ? "user-activity" : ""
            let duration = "(\(activitySummaryLevel.activity.duration)s)"
            html += "<p class='\(cssClass)'>\(indent)\(activitySummaryLevel.activity.title) \(duration)</p>"
            activitySummaryLevel.activity.attachments?.forEach { attachment in
                html += "<p>\(indent)<img class='screenshot' src='attachments/\(attachment.filename)' width='256'/></p>"
            }
        }
    }
}
