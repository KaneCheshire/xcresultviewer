//
//  ViewController.swift
//  XCResultViewer
//
//  Created by Kane Cheshire on 19/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Cocoa
import AppKit
import XMLCoder

class DragView: NSView {
    
    var dragStateHandler: ((Bool) -> Void)?
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        defer {
            dragStateHandler?(false)
        }
        let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) ?? []
        let xcresultURLs: [URL] = objs.compactMap { url in
            guard let url = url as? URL else { return nil }
            guard url.pathExtension == "xcresult" else { return nil }
            return url
        }
        guard xcresultURLs.count == 1 else { return }
        xcresultURLs.forEach { url in
            let enumerator = FileManager.default.enumerator(atPath: url.path)!
            let imagePaths: [String] = enumerator.compactMap { thing in
                guard let path = thing as? String else { return nil }
                guard path.contains("jpg") else { return nil }
                return "\(url.path)/\(path)"
            }
            let summariesPaths: [String] = FileManager.default.enumerator(atPath: url.path)!.compactMap { thing in
                guard let path = thing as? String else { return nil }
                guard path.contains("action_TestSummaries") else { return nil }
                return path
            }
            summariesPaths.forEach { path in
                let url = url.appendingPathComponent(path)
                let data = try! Data(contentsOf: url)
                let decoder = PropertyListDecoder()
                let result = try! decoder.decode(Result.self, from: data)
                handle(result: result, imagePaths: imagePaths)
            }
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        dragStateHandler?(false)
        return super.draggingExited(sender)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let res = super.draggingEntered(sender)
        guard let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) else { return res }
        let results: [Any] = objs.compactMap { url in
            guard let url = url as? URL else { return nil }
            guard url.pathExtension == "xcresult" else { return nil }
            return url
        }
        dragStateHandler?(results.count == 1)
        return res
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
                margin: 8pt;
            }
            div.summary {
                display:inline-block;
                vertical-align: top;
                padding:0 16pt 0 0;
                margin:0 8pt 0 0;
                background:rgb(39, 39, 39);
                border-radius:5pt;
            }
            img.screenshot {
                border-radius:5pt;
            }
        </style>
    </head>
    <body><div class='wrapper'>
"""
        
        result.TestableSummaries.forEach { summary in
            summary.Tests.forEach { test in
                test.ActivitySummaries?.forEach { summary in
                    summary.allSummaries(from: 0).forEach { summary in }
                }
                test.allTests(from: 0).forEach { test in
                    html += "<section><p>\(test.1.TestName)</p>"
                    
                    test.1.ActivitySummaries?.forEach { summary in
                        html += "<div class='summary'>"
                        
                        summary.allSummaries(from: test.0).forEach { summary in
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

class ViewController: NSViewController {
    
    @IBOutlet private var dropIndicationView: NSView!
    @IBOutlet private var dropHereLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.registerForDraggedTypes([.fileURL])
        dropIndicationView.wantsLayer = true
        dropIndicationView.layer?.borderColor = NSColor.gray.cgColor
        dropIndicationView.layer?.borderWidth = 5
        dropIndicationView.layer?.cornerRadius = 5
        dropHereLabel.textColor = .gray
        dropIndicationView.alphaValue = 0.5
        (view as? DragView)?.dragStateHandler = { [weak self] isDragging in
            self?.dropIndicationView.alphaValue = isDragging ? 1 : 0.5
        }
    }
    
}

typealias TestLevel = (Int, Result.TestableSummary.Test)
typealias Levels = (Int, Result.TestableSummary.Test.ActivitySummary)

extension Result.TestableSummary.Test {
    
    func allTests(from levelIndex: Int) -> [TestLevel] {
        var allTests: [TestLevel] = [(levelIndex, self)]
        if let subtests = Subtests {
            allTests.append(contentsOf: subtests.flatMap { $0.allTests(from: levelIndex + 1) })
        }
        return allTests
    }
    
}

extension Result.TestableSummary.Test.ActivitySummary {
    
    func allSummaries(from levelIndex: Int) -> [Levels] {
        var allSummaries: [Levels] = [(levelIndex, self)]
        if let subActivities = SubActivities {
            allSummaries.append(contentsOf: subActivities.flatMap { $0.allSummaries(from: levelIndex + 1) })
        }
        return allSummaries
    }
    
}
