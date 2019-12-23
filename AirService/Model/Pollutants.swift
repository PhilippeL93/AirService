//
//  Pollutants.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct Pollutants: Decodable {
    let meta: MetaDataPollutants
    let results: ResultsDataPollutants
}

struct MetaDataPollutants: Decodable {
    var name: String
    var license: String
    var website: URL
}

struct ResultsDataPollutants: Decodable {
    var id: String
    var name: Double
    var description: String
    var preferredUnit: String
}
