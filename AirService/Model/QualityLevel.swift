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
    var quality = ""
    var color = ""
    var level = 0.0

    static let listQualityLevel = [
        QualityLevel(indice: 1, quality: "Très bon", color: "Green", level: 12.5),
        QualityLevel(indice: 2, quality: "Très bon", color: "Green", level: 25),
        QualityLevel(indice: 3, quality: "Bon", color: "Light Green", level: 37.5),
        QualityLevel(indice: 4, quality: "Bon", color: "Light Green", level: 50),
        QualityLevel(indice: 5, quality: "Moyen", color: "Orange", level: 62.5),
        QualityLevel(indice: 6, quality: "Médiocre", color: "Orange", level: 75),
        QualityLevel(indice: 7, quality: "Mauvais", color: "Red", level: 87.5),
        QualityLevel(indice: 8, quality: "Mauvais", color: "Red", level: 100),
        QualityLevel(indice: 9, quality: "Très mauvais", color: "Dark Red", level: 9999999)
    ]
}
