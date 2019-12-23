//
//  LatestMeasures.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct LatestMeasures: Decodable {
    let meta: MetaDataLatestMeasures
    let results: [ResultsDataLatestMeasures]
}

struct MetaDataLatestMeasures: Decodable {
    var name: String
    var license: String
    var website: URL
    var page: Double
    var limit: Double
    var found: Double
}

struct ResultsDataLatestMeasures: Decodable {
    var location: String
    var city: String
    var country: String
    var distance: Double
    let measurements: [MeasuresDetail]
}

struct MeasuresDetail: Decodable {
    var parameters: String
    var value: Double
    var lastUpdated: Date
    var unit: String
    var sourceName: String
}
