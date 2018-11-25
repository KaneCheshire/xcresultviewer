//
//  ResultHandler.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import AppKit

struct ResultHandler {
    
    func handle(resultURL url: URL) {
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
            handle(result: result, imagePaths: imagePaths)
        }
    }
    
    private func ignoredActivityContents() -> [String] {
        return ["snapshot accessibility hierarchy",
                "to idle"]
    }
    
    private func handle(result: Result, imagePaths: [String]) {
        var html = """
<html>
    <head>
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
            body {
                padding:8pt;
            }
            .wrapper {
                width: 100%;
                overflow-y: hidden;
                white-space: nowrap;
                padding-bottom: 50px;
                vertical-align: top;
            }
            section {
                white-space: nowrap;
                display:inline-block;
                vertical-align: top;
                padding:16pt;
                background:rgb(24, 24, 24);
                border-radius:5pt;
            }
            div.summary {
                display:inline-block;
                vertical-align: top;
                padding:8pt 16pt 8pt;
                margin:16pt 8pt 0 0;
                background:rgb(39, 39, 39);
                border-radius:5pt;
            }
            div.summary p {
                padding:8pt 0;
            }
            img.screenshot {
                border-radius:5pt;
            }
        </style>
    </head>
    <body><div id='top' class='wrapper'>
"""
        
        result.TestableSummaries.forEach { summary in
            summary.Tests.forEach { test in
                test.ActivitySummaries?.forEach { summary in
                    summary.allSummaries(from: 0).forEach { summary in
                        
                    }
                }
                let allTests = test.allTests(from: 0)
                allTests.forEach { test in
                    html += "<section><p>\(test.1.TestName)</p>"
                    
                    test.1.ActivitySummaries?.forEach { summary in
                        html += "<div class='summary'>"
                        
                        summary.allSummaries(from: 0).forEach { summary in
                            for ignoredContent in ignoredActivityContents() where summary.1.Title.lowercased().contains(ignoredContent) {
                                return
                            }
                            let indent = String(repeating: "&nbsp;&nbsp;", count: summary.0)
                            if let attachment = summary.1.Attachments?.first, let imagePath = imagePaths.first(where: { $0.contains(attachment.Filename) }) {
                                let url = URL(fileURLWithPath: imagePath)
                                html += "<p>\(indent)\(summary.1.Title)</p><p>\(indent)<img class='screenshot' src='\(url.absoluteString)' width='256'/></p>"
                            } else {
                                html += "<p>\(indent)\(summary.1.Title)</p>"
                            }
                            
                        }
                        html += "</div>"
                    }
                }
                allTests.forEach { _ in
                    html += "</section>"
                }
            }
        }
        
        html += "</div></body></html>"
        let fileURL = URL(string: "file:///Users/kanecheshire/xcresult.html")!
        let htmlData = Data(html.utf8)
        try! htmlData.write(to: fileURL)
        NSWorkspace.shared.open(fileURL)
    }
    
}
