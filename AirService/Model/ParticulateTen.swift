//
//  ParticulateTen.swift
//  AirService
//
//  Created by Philippe on 01/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// PM10 Particulate matter less than 10 micrometers in diameter

struct ParticulateTen {
    var indice = 0
    var value = 0.0

    static let list = [
        ParticulateTen(indice: 1, value: 7),
        ParticulateTen(indice: 2, value: 14),
        ParticulateTen(indice: 3, value: 22),
        ParticulateTen(indice: 4, value: 29),
        ParticulateTen(indice: 5, value: 39),
        ParticulateTen(indice: 6, value: 49),
        ParticulateTen(indice: 7, value: 74),
        ParticulateTen(indice: 8, value: 09),
        ParticulateTen(indice: 9, value: 999999999)
    ]
}
