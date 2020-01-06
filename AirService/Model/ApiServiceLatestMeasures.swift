//
//  ApiServiceLatestMeasures.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - class
class ApiServiceLatestMeasures {

//    https://api.openaq.org/v1/latest?         location="FR09404"
//                                              country="XX"

    private let apiServiceUrl = "https://api.openaq.org/v1/latest?"

    // MARK: - functions
    /// function getApiLatestMeasures generate a call to API with Alamofire
    /// - preparing var for call
    /// - call function request of Alamofire (AF.request(url).responseJSON)
    /// - at call return
    /// - switch result = success ok
    ///     - call createMeasurementsObjectWith in order to deparse JSON
    ///         - if data like measurements
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - if count of measurements > 0
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - call function createListMeasurements
    ///         - exit of call with completion = true
    /// - other exit of call with completion = false
    ///
    func getApiLatestMeasures(typeOfSearch: String, itemToSearch: String, completion: @escaping
        (Bool, Errors?) -> Void) {

        let queryParams: [String: String] = [
            "limit": "9999",
            typeOfSearch: itemToSearch
        ]
        let api = apiServiceUrl
        guard let url = URL(string: api)?.appendParameters(params: queryParams)
            else { return completion(false, .noURL) }
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(false, .noData)
                    return
                }
                self.createMeasurementsObjectWith(json: data, completion: { (latestMeasures) in
                    guard let latestMeasures = latestMeasures else {
                        completion(false, .dataNotCompliant)
                        return
                    }
                    guard latestMeasures.results.count > 0 else {
                        completion(false, .noMeasurements)
                        return
                    }
                    self.createListMeasurements(type: latestMeasures)
                    completion(true, nil)
                }
                )
            case .failure:
                completion(false, .noInternetConnection)
            }
        }
    }

    /// function createListCountries
    ///     - loop in order to create listCountries contening contries found
    ///
    private func createListMeasurements(type: LatestMeasures) {
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let currentDateCompare = formatter.string(from: date)
        do {
            for indice in 0...type.results.count-1 {
                    calculateIndice()
                    let listLatestMeasures = ListLatestMeasure(
                        location: type.results[indice].location,
                        city: type.results[indice].city,
                        country: type.results[indice].country,
                        measurements: type.results[indice].measurements,
                        indice: 150
                    )
                    ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasures)
            }
            //        } catch {
            //            print(error)
        }
    }

    /// function createCountriesObjectWith
    /// using JSONDecoder and structure Countries in order to deparse JSON recceived
    ///
    private func createMeasurementsObjectWith(json: Data, completion: @escaping (_ data: LatestMeasures?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let latestMeasures = try decoder.decode(LatestMeasures.self, from: json)
            return completion(latestMeasures)
        } catch _ {
            return completion(nil)
        }
    }

    private func calculateIndice() {

    }
}
