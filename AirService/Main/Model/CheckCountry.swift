//
//  CheckCountry.swift
//  AirService
//
//  Created by Philippe on 02/02/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// MARK: - class CheckCountry
class CheckCountry {

    func checkCountry(country: String) -> String {
        switch country {
        case "FR":
            return "countryTypeOne"
        case "DE", "ES", "IE", "CZ":
            return "countryTypeTwo"
        default:
            return "otherCountry"
        }
    }
}
