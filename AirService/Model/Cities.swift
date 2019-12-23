//
//  Cities.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct Cities: Decodable {
    let meta: MetaDataCities
    let results: ResultsDataCities
}

struct MetaDataCities: Decodable {
    var name: String
    var license: String
    var website: URL
    var page: Double
    var limit: Double
    var found: Double
}

struct ResultsDataCities: Decodable {
    var id: String
    var country: String
    var city: Double
    let cities: [String]
    var location: String
    let locations: [String]
}
