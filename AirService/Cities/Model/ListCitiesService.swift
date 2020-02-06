//
//  ListCitiesService.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

// MARK: class ListCitiesService
///    in order to manage listCities
class ListCitiesService {

    // MARK: - variables
    ///   variables
    static var shared = ListCitiesService()
    private init() {}
    private(set) var listCities: [ListCitie] = []

    // MARK: - functions
    ///    add in order to add city to list of cities
    ///
    func add(listCitie: ListCitie) {
        listCities.append(listCitie)
    }

    ///    removeAll in order to remove all cities found
    func removeAll() {
        listCities.removeAll()
    }
}
