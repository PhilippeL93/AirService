//
//  ListLatestMeasuresDetailService.swift
//  AirService
//
//  Created by Philippe on 26/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import Foundation

// MARK: class ListLatestMeasuresDetailService
class ListLatestMeasuresDetailService {

    // MARK: - variables
    ///    variables
    static let shared = ListLatestMeasuresDetailService()
    private init() {}

    private(set) var listLatestMeasuresDetail: [ListLatestMeasuresDetail] = []

    // MARK: - functions
    ///    add in order to add country to list of countries
    func add(listLatestMeasureDetail: ListLatestMeasuresDetail) {
        listLatestMeasuresDetail.append(listLatestMeasureDetail)
    }

    ///    removeAll in order to remove all cities found
    func removeAll() {
        listLatestMeasuresDetail.removeAll()
    }
}
