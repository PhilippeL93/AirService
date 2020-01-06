//
//  ListLatestMeasuresService.swift
//  AirService
//
//  Created by Philippe on 01/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// MARK: class ListCountriesService
class ListLatestMeasuresService {

    // MARK: - variables
    /*    variables
            
     */
    static let shared = ListLatestMeasuresService()
    private init() {}

    private(set) var listLatestMeasures: [ListLatestMeasure] = []

    // MARK: - functions
    ///    function add in order to add country to list of countries
    ///
    func add(listLatestMeasure: ListLatestMeasure) {
        listLatestMeasures.append(listLatestMeasure)
    }
}
