//
//  Countries.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: - structure SearchCountries
/*    statement of JSON received by API
 */
struct Countries: Decodable {
    let meta: MetaDataCountries
    let results: ResultsDataCountries
}

struct MetaDataCountries: Decodable {
    var name: String
    var license: String
    var website: URL
    var page: Double
    var limit: Double
    var found: Double
}

struct ResultsDataCountries: Decodable {
    var code: String
    var count: Double
    var locations: Double
    var cities: Double
    var name: String
}
