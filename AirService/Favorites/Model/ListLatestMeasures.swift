//
//  ListLatestMeasures.swift
//  AirService
//
//  Created by Philippe on 31/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: struct ListLatestMeasure
///    contains measures extracted by ApiServiceLatestMeasures
struct ListLatestMeasure {
    let country: String
    let city: String
    let location: String
    let locations: String
    let qualityIndice: Int
    let qualityIndicator: Double
    let qualityName: String
    let qualityColor: String
    let pollutant: String
    let hourLastUpdated: String
    let sourceName: String
    var measurements: [ListLatestMeasuresDetail]
}
struct ListLatestMeasuresDetail {
    var parameter: String
    var value: Double
    var lastUpdated: String
    var unit: String
    var sourceName: String
    var indiceAtmo: Int
    var valueMin: Double
    var valueMax: Double
}
