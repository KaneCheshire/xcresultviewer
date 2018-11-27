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
        guard let imagePathsEnumerator = FileManager.default.enumerator(atPath: url.path) else {
            return print("Unable to create image paths enumerator")
        }
        let imagePaths: [String] = imagePathsEnumerator.compactMap { thing in
            guard let imagePath = thing as? String, imagePath.contains("jpg") else { return nil }
            return "\(url.path)/\(imagePath)"
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
            handle(res: result, imagePaths:imagePaths)
        }
    }
    
    private mutating func handle(res: Result, imagePaths: [String]) {
        appendBegginingHTML()
        res.testableSummaries.forEach { testableSummary in
            html += "<section><p>\(testableSummary.testName)</p>"
            testableSummary.testSummaryGroups.forEach { testSummaryGroup in
                html += "<section><p>\(testSummaryGroup.testName)</p>"
                testSummaryGroup.testSummarySubGroups.forEach { testSummarySubGroup in
                    html += "<section><p>\(testSummarySubGroup.testName)</p>"
                    testSummarySubGroup.tests.forEach { test in
                        guard test.containsFailures else { return }
                        html += "<section><p>\(test.testName)</p>"
                        test.subtests.forEach { subtest in
                            guard subtest.failureSummaries != nil else { return }
                            html += "<section><p>\(subtest.testName)</p>"
                            html += "<div class='summary'>"
                            subtest.activitySummaries.forEach { activitySummary in
                                let allSummaryLevels = activitySummary.allSummaryLevels()
                                let displayableSummaries = allSummaryLevels.filter { activitySummaryLevel in
                                    for ignoredContent in ignoredActivityContents() where activitySummaryLevel.activity.title.lowercased().contains(ignoredContent) {
                                        return false
                                    }
                                    return activitySummaryLevel.activity.containsAttachment
                                }
                                displayableSummaries.forEach { activitySummaryLevel in
                                    let indent = String(repeating: "&nbsp;&nbsp;", count: activitySummaryLevel.level)
                                    let cssClass = activitySummaryLevel.activity.activityType == .userCreated ? "user-activity" : ""
                                    let duration = "(\(activitySummaryLevel.activity.duration)s)"
                                    html += "<p class='\(cssClass)'>\(indent)\(activitySummaryLevel.activity.title) \(duration)</p>"
                                    if let attachment = activitySummaryLevel.activity.attachments?.first, let imagePath = imagePaths.first(where: { $0.contains(attachment.filename) }) {
                                        let url = URL(fileURLWithPath: imagePath)
                                        html += "<p>\(indent)<img class='screenshot' src='\(url.absoluteString)' width='256'/></p>"
                                    }
                                }
                            }
                            html += "</div>"
                            html += "</section>"
                        }
                        html += "</section>"
                    }
                    html += "</section>"
                }
                html += "</section>"
            }
            html += "</section>"
        }
        appendClosingHTML()
        let fileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("xcresult.html")
        let htmlData = Data(html.utf8)
        try! htmlData.write(to: fileURL)
        NSWorkspace.shared.open(fileURL)
    }
    
    private mutating func appendBegginingHTML() {
        html = """
        <html>
            <head>
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
        </head>
        <body>
        <div class='wrapper'>
        """
    }
    
    private mutating func appendClosingHTML() {
        html += """
        </div>
        </body>
        </html>
        """
    }
    
    private func ignoredActivityContents() -> [String] {
        return ["snapshot accessibility hierarchy"]
    }
    
}
