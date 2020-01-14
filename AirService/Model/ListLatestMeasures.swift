//
//  ListLatestMeasures.swift
//  AirService
//
//  Created by Philippe on 31/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

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
    var measurements: [MeasuresDetail]
}

//struct MeasuresDetail {
//    var parameter: String
//    var value: Double
//    var lastUpdated: Date
//    var unit: String
//    var sourceName: String
//}
