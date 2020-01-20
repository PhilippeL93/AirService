//
//  ParticulateTwoFive.swift
//  AirService
//
//  Created by Philippe on 01/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// PM2.5 Particulate matter less than 2.5 micrometers in diameter

struct ParticulateTwoFive {
    var indice = 0
    var value = 0.0

    static let list = [
        ParticulateTwoFive(indice: 1, value: 7),
        ParticulateTwoFive(indice: 2, value: 14),
        ParticulateTwoFive(indice: 3, value: 22),
        ParticulateTwoFive(indice: 4, value: 29),
        ParticulateTwoFive(indice: 5, value: 42),
        ParticulateTwoFive(indice: 6, value: 54),
        ParticulateTwoFive(indice: 7, value: 81),
        ParticulateTwoFive(indice: 8, value: 109),
        ParticulateTwoFive(indice: 9, value: 999)
    ]
}
