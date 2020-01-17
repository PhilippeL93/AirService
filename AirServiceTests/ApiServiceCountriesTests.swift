//
//  ApiServiceCountriesTests.swift
//  ApiServiceCountriesTests
//
//  Created by Philippe on 16/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import XCTest
import Mockingjay
@testable import AirService

class ApiServiceCountriesTests: XCTestCase {
    private let apiFetcherCountries = ApiServiceCountries()

    /// Put setup code here. This method is called before the invocation of each test method in the class.
    /// in order to initialize var
    override func setUp() {
        super.setUp()
        let url = Bundle(for: type(of: self)).url(forResource: "Countries", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        stub(uri("https://api.openaq.org/v1/countries?"), jsonData(data))
//        initStubs() // Create stubs

    }
    // MARK: - testing API for Countries
    func testGetCountris_ShouldPostSuccesCallBack_IfNoErrorAndCorrectData() {
        // Given
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCountries.getApiCountries() { (success, errors ) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(errors)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testGetCountris_ShouldPostFailedCallBack_IfNoErrorAndDataNotCountries() {
        // Given
        let body = ["some":"data"]
        
        // Define Stub
        stub(everything, json(body))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCountries.getApiCountries() { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .dataNotCompliant)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

//    func testGetCountris_ShouldPostFailedCallBack_IfNoErrorAndDataNoCountriesFound() {
//        // Given
//        let body = [String: String]
//        
//        // Define Stub
//        stub(everything, json(body))
//        // When
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        apiFetcherCountries.getApiCountries() { (success, errors ) in
//            // Then
//            XCTAssertFalse(success)
//            XCTAssertEqual(errors, .dataNotCompliant)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//    }

    func testGetCountris_ShouldPostFailedCallBack_IfNoInternetConnection() {
        // Given
        let error = NSError(domain: "com.cocoacasts.network", code: 1, userInfo: nil)
        // Define Stub
        stub(everything, failure(error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiFetcherCountries.getApiCountries() { (success, errors ) in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(errors, .noInternetConnection)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
