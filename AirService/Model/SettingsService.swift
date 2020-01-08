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
}
