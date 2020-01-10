//
//  SettingsService.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

class SettingsService {
    private struct Keys {
        static let countryISO = "countryISO"
        static let localization = "localization"
        static let favoriteCity = "favoriteCity"
//        private var favoriteCityList = [String] ()
        private var favoriteCityList: [CityFavorite]
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
//    static var favoriteCityList: [String] {
//        get {
//            UserDefaults.standard.object(forKey: Keys.favoriteCity) as? [String] ?? [""]
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Keys.favoriteCity)
//        }
//    }
    static var favoriteCityList: [CityFavorite] {
        get {
            UserDefaults.standard.object(forKey: Keys.favoriteCity) as? [CityFavorite] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.favoriteCity)
        }
    }
}

struct CityFavorite {
    let ident: String
    let country: String
    let city: String
    let location: String
}
