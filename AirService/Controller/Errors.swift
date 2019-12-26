//
//  Errors.swift
//  Reciplease
//
//  Created by Philippe on 05/11/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: enum Errors
enum Errors: String {
    case noInternetConnection = "No Internet Connection"
    case noData = "No Data extracted from API"
    case dataNotCompliant = "data not compliant with api"
    case noCountries = "No countries found"
    case noCities = "No cities found"
    case noURL = "URL not compliant"
}
