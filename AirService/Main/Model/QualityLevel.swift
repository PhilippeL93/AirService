//
//  QualityLevel.swift
//  AirService
//
//  Created by Philippe on 01/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// MARK: - structure QualityLevel
///    values for Air Quality level
struct QualityLevel {
    var indice = 0
    var name = ""
    var color = ""
    var level = 0.0

    static let list = [
        QualityLevel(indice: 1, name: "Très bon", color: "colorLevelOne", level: 12.5),
        QualityLevel(indice: 2, name: "Très bon", color: "colorLevelTwo", level: 25.0),
        QualityLevel(indice: 3, name: "Bon", color: "colorLevelThree", level: 37.5),
        QualityLevel(indice: 4, name: "Bon", color: "colorLevelFour", level: 50),
        QualityLevel(indice: 5, name: "Moyen", color: "colorLevelFive", level: 62.5),
        QualityLevel(indice: 6, name: "Médiocre", color: "colorLevelSix", level: 75),
        QualityLevel(indice: 7, name: "Mauvais", color: "colorLevelSeven", level: 87.5),
        QualityLevel(indice: 8, name: "Mauvais", color: "colorLevelEight", level: 100),
        QualityLevel(indice: 9, name: "Très mauvais", color: "colorLevelNine", level: 200)
    ]
}
