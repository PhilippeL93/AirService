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
    /*    variables
            
     */
    static let shared = ListCountriesService()
    private init() {}

    private(set) var listCountries: [ListCountrie] = []

    // MARK: - functions
    ///    function add in order to add recipe to list of countries
    ///
    func add(listCountrie: ListCountrie) {
        listCountries.append(listCountrie)
    }
}
