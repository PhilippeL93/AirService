//
//  OldSettingsService.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

class OldSettingsService {

    private struct Keys {
        static let countryISO = "countryISO"
        static let localization = "localization"
        static let favoriteCities = "favoriteCities"
//        private var favoriteCitiesList: [CitiesFavorite]?
    }

    static var countryISO: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.countryISO) ?? "FR"
        }
        set {
             UserDefaults.standard.set(newValue, forKey: Keys.countryISO)
        }
    }
    static var localization: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.localization) ?? "GeoLocalization"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.localization)
        }
    }
    static var favoriteCitiesList: [CitiesFavorite] {
        get {
            guard let dataCities = UserDefaults.standard.object(forKey: Keys.favoriteCities) as? Data else {
                return []
            }
            guard let data = try? JSONDecoder().decode([CitiesFavorite].self, from: dataCities) else {
                return []
            }
            return data
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.favoriteCities)
        }
    }
}

//struct CitiesFavorite: Codable {
//    let ident: String
//    let country: String
//    let city: String
//    let location: String
//    let locations: String
//}
