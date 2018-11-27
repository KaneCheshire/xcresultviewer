//
//  Array+Safe.swift
//  xcresultviewer
//
//  Created by Kane Cheshire on 25/11/2018.
//  Copyright © 2018 kane.codes. All rights reserved.
//

import Foundation

extension Array {
    
    subscript(safeAt index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
