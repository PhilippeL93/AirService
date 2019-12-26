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
        static let country = "country"
    }
    static var country: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.country) ?? "FR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.country)
        }
    }
}
