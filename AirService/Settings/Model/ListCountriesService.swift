//
//  ListCountriesService.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: class ListCountriesService
class ListCountriesService {

    // MARK: - variables
    ///    variables
    static let shared = ListCountriesService()
    private init() {}
    private(set) var listCountries: [ListCountrie] = []

    // MARK: - functions
    ///    add in order to add country to list of countries
    func add(listCountrie: ListCountrie) {
        listCountries.append(listCountrie)
    }
}
