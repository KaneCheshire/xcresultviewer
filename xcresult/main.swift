//
//  main.swift
//  xcresult
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

enum Flag: String {
	case machineFriendly = "-m"
	case `default` = ""
	
	init(rawValue: String) {
		switch rawValue {
		case "-m": self = .machineFriendly
		default: self = .default
		}
	}
}

if let resultArgument = ProcessInfo.processInfo.arguments[safeAt: 1] {
	let result = Flag(rawValue: resultArgument)
	let shouldOpenResultFile = result == .default
	switch result {
	case .machineFriendly:
		if let urlString = ProcessInfo.processInfo.arguments[safeAt: 2] {
			let url = URL(fileURLWithPath: urlString)
			ResultHandler().handle(resultURL: url, shouldOpenResultFile: shouldOpenResultFile)
		}
	default:
		let url = URL(fileURLWithPath: resultArgument)
		ResultHandler().handle(resultURL: url, shouldOpenResultFile: shouldOpenResultFile)
	}
} else {
	print("Missing path to xcresult")
}
