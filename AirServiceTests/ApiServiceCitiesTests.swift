//
//  ApiServiceCitiesTests.swift
//  AirServiceTests
//
//  Created by Philippe on 15/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import XCTest
import Mockingjay
@testable import AirService

class ApiServiceCitiesTests: XCTestCase {
    private let apiFetcherCities = ApiServiceCities()
    private var countryToSearch = ""
    private var cityToSearch = ""
    private var typeOfSearch = ""

    /// Put setup code here. This method is called before the invocation of each test method in the class.
    /// in order to initialize var
    override func setUp() {
        super.setUp()
        let url = Bundle(for: type(of: self)).url(forResource: "Cities", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        stub(uri("https://api.openaq.org/v1/locations?"), jsonData(data))
//        initStubs() // Create stubs

    }
    // MARK: - testing API for Cities
    func testGetCitiesFR_ShouldPostSuccesCallBack_IfNoErrorAndCorrectData() {
        // Given
        countryToSearch = "FR"
        cityToSearch = "Paris"
        typeOfSearch = "location[]"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(errors)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCitiesDE_ShouldPostSuccesCallBack_IfNoErrorAndCorrectData() {
        // Given
        countryToSearch = "DE"
        cityToSearch = "Berlin"
        typeOfSearch = "city"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(errors)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCities_ShouldPostSuccesCallBack_IfNoErrorAndCorrectData() {
        // Given
        countryToSearch = "US"
        cityToSearch = "New york"
        typeOfSearch = "city"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(errors)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetCities_ShouldPostFailedCallBack_IfNoErrorAndDataNotCities() {
        // Given
        countryToSearch = "FR"
        cityToSearch = "Paris"
        typeOfSearch = "city"
        let body = ["some":"data"]
        
        // Define Stub
        stub(everything, json(body))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
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
        countryToSearch = "FR"
        cityToSearch = "Paris"
        typeOfSearch = "city"
        // Define Stub
        stub(everything, failure(error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
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
        cityToSearch = "Inconnu"
        typeOfSearch = "city"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCities.getApiCities(countryToSearch: countryToSearch, cityToSearch: cityToSearch,
        typeOfSearch: typeOfSearch) { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .noCities)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}

