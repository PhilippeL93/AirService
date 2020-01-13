//
//  ListLatestMeasures.swift
//  AirService
//
//  Created by Philippe on 31/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct ListLatestMeasure {
    let location: String
    let city: String
    let country: String
    let qualityIndicator: Double
    let qualityName: String
    let qualityColor: String
    let pollutant: String
    let hourLastUpdated: String
    var measurements: [MeasuresDetail]
}

//struct MeasuresDetail {
//    var parameter: String
//    var value: Double
//    var lastUpdated: Date
//    var unit: String
//    var sourceName: String
//}
