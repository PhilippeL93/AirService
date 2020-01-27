//
//  ApiServiceCountries.swift
//  AirService
//
//  Created by Philippe on 23/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - class ApiServiceCountries
class ApiServiceCountries {

    private let apiServiceUrl = "https://api.openaq.org/v1/countries?"

    // MARK: - functions
    /// function getApiCountries generate a call to API with Alamofire
    /// - preparing var for call
    /// - call function request of Alamofire (AF.request(url).responseJSON)
    /// - at call return
    /// - switch result = success ok
    ///     - call createCountriesObjectWith in order to deparse JSON
    ///         - if data like countries
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - if count of countries > 0
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - call function createListCountries
    ///         - exit of call with completion = true
    /// - other exit of call with completion = false
    ///
    func getApiCountries(completion: @escaping (Bool, Errors?) -> Void) {

        let queryParams: [String: String] = [
            "limit": "9999"
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
                    self.createCountriesObjectWith(json: data, completion: { (countries) in
                        guard let countries = countries else {
                            completion(false, .dataNotCompliant)
                            return
                        }
                        guard countries.results.count > 0 else {
                            completion(false, .noCountries)
                            return
                        }
                        self.createListCountries(type: countries)
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
    private func createListCountries(type: Countries) {
        do {
            for indice in 0...type.results.count-1 {
                let listCountries = ListCountrie(
                    code: type.results[indice].code,
                    count: type.results[indice].count,
                    locations: type.results[indice].locations,
                    cities: type.results[indice].cities,
                    name: type.results[indice].name ?? " "
                )
                ListCountriesService.shared.add(listCountrie: listCountries)
            }
        }
    }

    /// function createCountriesObjectWith
    /// using JSONDecoder and structure Countries in order to deparse JSON recceived
    ///
    private func createCountriesObjectWith(json: Data, completion: @escaping (_ data: Countries?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let countries = try decoder.decode(Countries.self, from: json)
            return completion(countries)
        } catch _ {
            return completion(nil)
        }
    }
}
