//
//  ResultHandler.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import AppKit

/// Handles turning an xcresult into html and displaying to the user
struct ResultHandler {
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Handles a URL, expecting the URL to be a path to an xcresult directory.
	func handle(resultURL url: URL, shouldOpenResultFile: Bool) {
        guard url.pathExtension == "xcresult" else {
            return print("Provided path is not to an xcresult")
        }
        guard let summariesEnumerator = FileManager.default.enumerator(atPath: url.path) else {
            return print("Unable to create summaries enumerator")
        }
        summariesEnumerator.forEach { thing in
            guard let path = thing as? String, path.contains("action_TestSummaries.plist") else { return }
            let data = try? Data(contentsOf: url.appendingPathComponent(path))
            guard let result = try? PropertyListDecoder().decode(Result.self, from: data ?? Data()) else {
                return print("Unable to decode Result object from plist at path", path)
            }
            handle(res: result, xcresultURL: url, shouldOpenResultFile: shouldOpenResultFile)
        }
    }
    
    // MARK: - Private -
    
	private func handle(res: Result, xcresultURL: URL, shouldOpenResultFile: Bool) {
        var html = initialHTML()
        res.testableSummaries.forEach { testableSummary in
            handle(testableSummary: testableSummary, html: &html)
        }
        html += "</div></body></html>"
        let fileURL = xcresultURL.appendingPathComponent("xcresult.html")
        let htmlData = Data(html.utf8)
        do {
            try htmlData.write(to: fileURL)
			if shouldOpenResultFile {
				NSWorkspace.shared.open(fileURL)
			} else {
				print("You can find the generated HTML at \(fileURL.absoluteString).")
			}
        } catch {
            print("Unable to write html to url", fileURL, error.localizedDescription)
        }
    }
    
    private func initialHTML() -> String {
        return """
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
                    background:rgba(10, 10, 10, 0.5);
                    box-shadow: 0 2pt 10pt 0 rgba(10, 10, 10, 0.9);
                    z-index:1;
                }
                img.screenshot {
                    border-radius:20pt;
                }
                p.user-activity {
                    background:rgb(42, 42, 42) !important;
                    border-radius:5pt;
                    padding-left:8pt !important;
                }
            </style>
        </head><body><div class='wrapper'>
        """
    }
    
    private func handle(testableSummary: TestableSummary, html: inout String) {
        html += "<section><p>\(testableSummary.testName)</p>"
        testableSummary.testSummaryGroups.forEach { testSummaryGroup in
            handle(testSummaryGroup: testSummaryGroup, html: &html)
        }
        html += "</section>"
    }
    
    private func handle(testSummaryGroup: TestSummaryGroup, html: inout String) {
        html += "<section><p>\(testSummaryGroup.testName)</p>"
        testSummaryGroup.testSummarySubGroups.forEach { testSummarySubGroup in
            handle(testSummarySubGroup: testSummarySubGroup, html: &html)
        }
        html += "</section>"
    }
    
    private func handle(testSummarySubGroup: TestSummarySubGroup, html: inout String) {
        html += "<section><p>\(testSummarySubGroup.testName)</p>"
        testSummarySubGroup.tests.reversed().forEach { test in
            handle(test: test, html: &html)
        }
        html += "</section>"
    }
    
    private func handle(test: Test, html: inout String) {
        guard test.containsFailures else { return }
        html += "<section><p>\(test.testName)</p>"
        test.subtests.forEach { subtest in
            handle(subtest: subtest, html: &html)
        }
        html += "</section>"
    }
    
    private func handle(subtest: SubTest, html: inout String) {
        guard subtest.failureSummaries != nil else { return }
        html += "<section><p>\(subtest.testName)</p><div class='summary'>"
        subtest.activitySummaries.reversed().forEach { activitySummary in
            handle(activitySummary: activitySummary, html: &html)
        }
        html += "</div></section>"
    }
    
    private func handle(activitySummary: ActivitySummary, html: inout String) {
        let allSummaryLevels = activitySummary.allSummaryLevels()
        let displayableSummaries = allSummaryLevels.filter { activitySummaryLevel in
            guard !activitySummaryLevel.activity.title.contains("snapshot accessibility hierarchy") else { return false }
            return activitySummaryLevel.activity.containsAttachment
        }
        displayableSummaries.reversed().forEach { activitySummaryLevel in
            handle(activitySummaryLevel: activitySummaryLevel, html: &html)
        }
    }
    
    private func handle(activitySummaryLevel: ActivitySummary.ActivitySummaryLevel, html: inout String) {
        let indent = String(repeating: "&nbsp;&nbsp;", count: activitySummaryLevel.level)
        let cssClass = activitySummaryLevel.activity.activityType == .userCreated ? "user-activity" : ""
        let duration = "(\(activitySummaryLevel.activity.duration)s)"
        html += "<div><p style='position:-webkit-sticky;top:0;' class='\(cssClass)'>\(indent)\(activitySummaryLevel.activity.title) \(duration)</p>"
        activitySummaryLevel.activity.attachments?.forEach { attachment in
            html += "<p>\(indent)<img class='screenshot' src='attachments/\(attachment.filename)' width='256'/></p>"
        }
        html += "</div>"
    }
}
