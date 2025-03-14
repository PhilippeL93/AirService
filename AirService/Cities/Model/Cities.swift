//
//  Cities.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: - structure Cities
///    statement of JSON received by ApiServiceCities
struct Cities: Decodable {
    let results: [ResultsDataCities]
}

struct ResultsDataCities {
    let ident: String
    let country: String
    let city: String
    let cities: [String]
    let location: String
    let locations: [String]
    let lastUpdated: String
}

extension ResultsDataCities: Decodable {
    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case country
        case city
        case cities
        case location
        case locations
        case lastUpdated
    }
}
