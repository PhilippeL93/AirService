//
//  Countries.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: - structure Countries
/*    statement of JSON received by ApiServiceCountries
 */
struct Countries: Decodable {
    let results: [ResultsDataCountries]
}

struct ResultsDataCountries: Decodable {
    var code: String
    var count: Int
    var locations: Int
    var cities: Int
    var name: String?
}
