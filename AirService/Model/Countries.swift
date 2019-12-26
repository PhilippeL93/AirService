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
//    let meta: MetaDataCountries
    let results: [ResultsDataCountries]
}

//struct MetaDataCountries: Decodable {
//    let name: String
//    let license: String
//    let website: String
//    let page: Int
//    let limit: Int
//    let found: Int
//}

struct ResultsDataCountries: Decodable {
    var code: String
    var count: Int
    var locations: Int
    var cities: Int
    var name: String?
}
