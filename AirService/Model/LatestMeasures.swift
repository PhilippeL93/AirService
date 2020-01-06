//
//  LatestMeasures.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct LatestMeasures: Decodable {
//    let meta: MetaDataLatestMeasures
    var results: [ResultsDataLatestMeasures]
}

//struct MetaDataLatestMeasures: Decodable {
//    var name: String
//    var license: String
//    var website: URL
//    var page: Double
//    var limit: Double
//    var found: Double
//}

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
