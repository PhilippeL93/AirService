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

struct ResultsDataPollutants {
    let ident: String
    let name: Double
    let description: String
    let preferredUnit: String
}

extension ResultsDataPollutants: Decodable {
    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case name
        case description
        case preferredUnit
    }
}
