//
//  SettingsServiceTests.swift
//  AirServiceTests
//
//  Created by Philippe on 15/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import XCTest
@testable import AirService

class SettingsServiceTests: XCTestCase {

    func testGivenGeoLocalization_WhenGetUserDefault_thenUserDefaultsEqualGeolocalization() {
        
        let mockSettingsContainer = MockSettingsContainer()
        let userDefaultsService = SettingsService(settingsContainer: mockSettingsContainer)
        // Given
        userDefaultsService.localization = "GeoLocalization"
        
        // When
        let localization = userDefaultsService.localization
        
        // Then
        XCTAssertEqual(localization, "GeoLocalization")
    }

    func testGivenCountrySelected_WhenGetUserDefault_thenUserDefaultsEqualToCountrySelected() {
        
        let mockSettingsContainer = MockSettingsContainer()
        let userDefaultsService = SettingsService(settingsContainer: mockSettingsContainer)
        // Given
        userDefaultsService.localization = "country"
        userDefaultsService.countryISO = "GB"
        
        // When
        let localization = userDefaultsService.localization
        let countryISO = userDefaultsService.countryISO
        
        // Then
        XCTAssertEqual(localization, "country")
        XCTAssertEqual(countryISO, "GB")
    }
    
    func testGivenOneFavoriteAdded_WhenGetUserDefault_thenCountUserDefaultsEqualPlusOne() {
        
        let mockSettingsContainer = MockSettingsContainer()
        let userDefaultsService = SettingsService(settingsContainer: mockSettingsContainer)
        // Given
        var citiesFavorite: [CitiesFavorite]?
        let settingsService = SettingsService()
        citiesFavorite = settingsService.favoriteCitiesList
        var citiesFavoriteCountBefore: Int = 0
        citiesFavoriteCountBefore = citiesFavorite?.count ?? 0
        
        // When
        let cityFavorite = CitiesFavorite(
            ident: "ident",
            country: "country",
            city: "city",
            location: "location",
            locations: "locations"
        )
        citiesFavorite?.append(cityFavorite)
        userDefaultsService.favoriteCitiesList = (citiesFavorite ?? [])!
        
        let citiesFavoriteCountAfter = citiesFavorite?.count
        
        // Then
        XCTAssertEqual(citiesFavoriteCountAfter, citiesFavoriteCountBefore+1)
    }
}

class MockSettingsContainer: SettingsContainer {
    var countryISO: String?
    var localization: String?
    var favoriteCitiesList: [CitiesFavorite]?
}
