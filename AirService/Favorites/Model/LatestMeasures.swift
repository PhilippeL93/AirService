//
//  LatestMeasures.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: - structure LatestMeasures
/*    statement of JSON received by ApiServiceLatestMeasures
 */
struct LatestMeasures: Decodable {
    var results: [ResultsDataLatestMeasures]
}

struct ResultsDataLatestMeasures: Decodable {
    var location: String
    var city: String
    var country: String
    var measurements: [MeasuresDetail]
}

struct MeasuresDetail: Decodable {
    var parameter: String
    var value: Double
    var lastUpdated: String
    var unit: String
    var sourceName: String
}
