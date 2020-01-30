//
//  String+Shared.swift
//  AirService
//
//  Created by Philippe on 11/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (indice: Int) -> String {
        return self[indice ..< indice + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (rangeToExamine: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, rangeToExamine.lowerBound)),
                                            upper: min(length, max(0, rangeToExamine.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
