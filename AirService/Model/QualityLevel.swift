//
//  QualityLevel.swift
//  AirService
//
//  Created by Philippe on 01/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

struct QualityLevel {
    var indice = 0
    var name = ""
    var color = ""
    var level = 0.0

    static let list = [
        QualityLevel(indice: 1, name: "Très bon", color: "greenOne", level: 12.5),
        QualityLevel(indice: 2, name: "Très bon", color: "greenTwo", level: 25.0),
        QualityLevel(indice: 3, name: "Bon", color: "greenThree", level: 37.5),
        QualityLevel(indice: 4, name: "Bon", color: "greenFour", level: 50),
        QualityLevel(indice: 5, name: "Moyen", color: "orangeFive", level: 62.5),
        QualityLevel(indice: 6, name: "Médiocre", color: "orangeSix", level: 75),
        QualityLevel(indice: 7, name: "Mauvais", color: "redSeven", level: 87.5),
        QualityLevel(indice: 8, name: "Mauvais", color: "redEight", level: 100),
        QualityLevel(indice: 9, name: "Très mauvais", color: "redNine", level: 9999999)
    ]
}
