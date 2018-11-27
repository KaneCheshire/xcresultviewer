//
//  main.swift
//  xcresult
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

if let resultArgument = ProcessInfo.processInfo.arguments[safeAt: 1] {
    let url = URL(fileURLWithPath: resultArgument)
    ResultHandler().handle(resultURL: url)
} else {
    print("Missing path to xcresult")
}
