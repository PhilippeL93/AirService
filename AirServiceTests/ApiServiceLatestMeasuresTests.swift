//
//  ApiServiceLatestMeasuresTests.swift
//  AirServiceTests
//
//  Created by Philippe on 15/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import XCTest
import Mockingjay
@testable import AirService

class ApiServiceLatestMeasuresTests: XCTestCase {
    private let apiFetchMeasures = ApiServiceLatestMeasures()
    private var countryToSearch = ""
    private var cityToSearch = ""
    private var locationToSearch = ""

    /// Put setup code here. This method is called before the invocation of each test method in the class.
    /// in order to initialize var
    override func setUp() {
        super.setUp()
        let url = Bundle(for: type(of: self)).url(forResource: "LatestMeasures", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        stub(uri("https://api.openaq.org/v1/latest?"), jsonData(data))
//        initStubs() // Create stubs
    }
    func initFavorite() {
        ListLatestMeasuresService.shared.removeAll()
        let measuresDetailOne = MeasuresDetail(
            parameter: "co",
            value: 10,
            lastUpdated: "2020-01-15T08:00:00.000Z",
            unit: "µg/m³",
            sourceName: "EEA France")
        let listLatestMeasuresOne = ListLatestMeasure(
            country: "countryOne",
            city: "cityOne",
            location: "locationOne",
            locations: "locationsOne",
            qualityIndice: 15,
            qualityIndicator: 10,
            qualityName: "trés bien",
            qualityColor: "green",
            pollutant: "co",
            hourLastUpdated: "2020-01-15T08:00:00.000Z",
            sourceName: "EEA France",
            measurements: [measuresDetailOne]
        )
        ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasuresOne)
        
        let measuresDetailTwo = MeasuresDetail(
            parameter: "co",
            value: 10,
            lastUpdated: "2020-01-15T08:00:00.000Z",
            unit: "µg/m³",
            sourceName: "EEA France")
        let listLatestMeasuresTwo = ListLatestMeasure(
            country: "countryTwo",
            city: "cityTwo",
            location: "locationTwo",
            locations: "locationsTwo",
            qualityIndice: 15,
            qualityIndicator: 10,
            qualityName: "trés bien",
            qualityColor: "green",
            pollutant: "co",
            hourLastUpdated: "2020-01-15T08:00:00.000Z",
            sourceName: "EEA France",
            measurements: [measuresDetailTwo]
        )
        ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasuresTwo)
        
        let measuresDetailThree = MeasuresDetail(
            parameter: "co",
            value: 10,
            lastUpdated: "2020-01-15T08:00:00.000Z",
            unit: "µg/m³",
            sourceName: "EEA France")
        let listLatestMeasuresThree = ListLatestMeasure(
            country: "countryThree",
            city: "cityThree",
            location: "locationThree",
            locations: "locationsThree",
            qualityIndice: 15,
            qualityIndicator: 10,
            qualityName: "trés bien",
            qualityColor: "green",
            pollutant: "co",
            hourLastUpdated: "2020-01-15T08:00:00.000Z",
            sourceName: "EEA France",
            measurements: [measuresDetailThree]
        )
        ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasuresThree)
    }
    // MARK: - testing API for Latest Measures
    func testGetCities_ShouldPostSuccesCallBack_IfNoErrorAndCorrectData() {
        // Given
        countryToSearch = "DE"
        cityToSearch = "Margit von Döhren"
        locationToSearch = "Kaiserslautern-Rathausplatz"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch, locationToSearch: locationToSearch, cityToSearch: cityToSearch) { (success, errors ) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(errors)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCities_ShouldPostFailedCallBack_IfNoErrorAndDataNotCities() {
        // Given
        countryToSearch = "DE"
        cityToSearch = "Margit von Döhren"
        locationToSearch = "Kaiserslautern-Rathausplatz"
        let body = ["some":"data"]
        
        // Define Stub
        stub(everything, json(body))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch, locationToSearch: locationToSearch, cityToSearch: cityToSearch) { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .dataNotCompliant)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCities_ShouldPostFailedCallBack_IfNoInternetConnection() {
        // Given
        let error = NSError(domain: "com.cocoacasts.network", code: 1, userInfo: nil)
        countryToSearch = "DE"
        cityToSearch = "Margit von Döhren"
        locationToSearch = "Kaiserslautern-Rathausplatz"
        // Define Stub
        stub(everything, failure(error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch, locationToSearch: locationToSearch, cityToSearch: cityToSearch) { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .noInternetConnection)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCities_ShouldPostSuccesCallBack_IfNoErrorAndNoDataFound() {
        // Given
        countryToSearch = "FR"
        cityToSearch = "Berlin"
        locationToSearch = "DEBE010"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch, locationToSearch: locationToSearch, cityToSearch: cityToSearch) { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .noMeasurements)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGivenRemoveMeasure_WhenDeletedCellSelected_thenCountOfListLatestMeasureIncreasedOfOne() {
        // Given
        initFavorite()
        let numberOfMeasuresBefore = ListLatestMeasuresService.shared.listLatestMeasures.count
    
        // When
       ListLatestMeasuresService.shared.removeFavorite(at: 0)
        let numberOfMeasuresAfter = ListLatestMeasuresService.shared.listLatestMeasures.count
        
        // Then
        XCTAssertEqual(numberOfMeasuresAfter, numberOfMeasuresBefore-1)
    }

    func testGivenRemoveAllMeasure_WhenDeletedAllFavorites_thenCountOfListLatestMeasureEqualZero() {
        // Given
        initFavorite()
        let numberOfMeasuresBefore = ListLatestMeasuresService.shared.listLatestMeasures.count
    
        // When
       ListLatestMeasuresService.shared.removeAll()
        let numberOfMeasuresAfter = ListLatestMeasuresService.shared.listLatestMeasures.count
        
        // Then
        XCTAssertEqual(numberOfMeasuresBefore, 3)
        XCTAssertEqual(numberOfMeasuresAfter, 0)
    }

}


