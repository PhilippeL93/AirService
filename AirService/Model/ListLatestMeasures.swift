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
    var measurements: [MeasuresDetail]
    let indice: Int
}

//struct MeasuresDetail {
//    var parameter: String
//    var value: Double
//    var lastUpdated: Date
//    var unit: String
//    var sourceName: String
//}
