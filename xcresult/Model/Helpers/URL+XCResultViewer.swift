//
//  URL+XCResultViewer.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 03/07/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import Foundation

extension URL {
    
    var isXCResult: Bool {
        return pathExtension == "xcresult"
    }
    
    func testRuns() -> [TestRun] {
        guard let enumerator = FileManager.default.enumerator(atPath: path) else { fatalError("Unable to create summaries enumerator") }
        return enumerator.compactMap { item in
            guard let path = item as? String, path.contains("action_TestSummaries.plist") else { return nil }
            let data = try? Data(contentsOf: appendingPathComponent(path))
            return try? PropertyListDecoder().decode(TestRun.self, from: data ?? Data())
        }
    }
    
}
