//
//  Settings.swift
//  AirService
//
//  Created by Philippe on 19/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// MARK: - class
/// class SettingsService in order to manage userDefaults
///  three user defaults are stored
///   - one contening country prefered
///   - one contening geolocalization or not
///   - onr contening favorties
///

class Settings {
    private var settingsContainer: SettingsContainer

    init(settingsContainer: SettingsContainer = UserDefaultsContainer()) {
        self.settingsContainer = settingsContainer
    }
    var countryISO: String? {
        get {
            return settingsContainer.countryISO
        }
        set {
            settingsContainer.countryISO = newValue
        }
    }
    var localization: String? {
        get {
            return settingsContainer.localization
        }
        set {
            settingsContainer.localization = newValue
        }
    }
    var favoriteCitiesList: [CitiesFavorite]? {
        get {
            return settingsContainer.favoriteCitiesList
        }
        set {
            settingsContainer.favoriteCitiesList = newValue
        }
    }
}

struct CitiesFavorite: Codable {
    let ident: String
    let country: String
    let city: String
    let location: String
    let locations: String
}

/// protocol SettingsContainer in order to manage mock for userDefaults
///   required for tests
///
protocol SettingsContainer {
    var countryISO: String? { get set }
    var localization: String? { get set }
    var favoriteCitiesList: [CitiesFavorite]? { get set }
}

class UserDefaultsContainer {
    private struct Keys {
        static let countryISO = "partageTokenKey"
        static let localization = "localization"
        static let favoriteCities = "favoriteCities"
        private var favoriteCitiesList: [CitiesFavorite]?
    }
}

extension UserDefaultsContainer: SettingsContainer {

    var countryISO: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.countryISO)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.countryISO)
        }
    }
    var localization: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.localization)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.localization)
        }
    }
    var favoriteCitiesList: [CitiesFavorite]? {
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
