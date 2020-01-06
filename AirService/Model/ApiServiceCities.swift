//
//  ApiServiceCities.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - class
class ApiServiceCities {

    private let apiServiceUrl = "https://api.openaq.org/v1/locations?"
    private var request: DataRequest?

    // MARK: - functions
    /// function getApiCities generate a call to API with Alamofire
    /// - preparing var for call
    /// - call function request of Alamofire (AF.request(url).responseJSON)
    /// - at call return
    /// - switch result = success ok
    ///     - call createCitiesObjectWith in order to deparse JSON
    ///         - if data like cities
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - if count of cities > 0
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - call function createListCities
    ///         - exit of call with completion = true
    /// - other exit of call with completion = false
    ///
    func getApiCities(countryToSearch: String, cityToSearch: String,
                      typeOfSearch: String, completion: @escaping (Bool, Errors?) -> Void) {

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        var parameters = ""
        var url = ""
        var urlString = ""

        let api = apiServiceUrl
        parameters = "country=" + countryToSearch + "&" + typeOfSearch + "=" + cityToSearch +
            "&limit=9999" + "&activationDate=" +
            currentDate + "&activationDate="  + currentDate

        url = api + parameters

        urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        print("urlString \(urlString)")
        if typeOfSearch == "location[]" {
            ListCitiesService.shared.removeAll()
            request?.cancel()
        }

        request = AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion(false, .noData)
                    return
                }
                self.createCitiesObjectWith(json: data, completion: { (cities) in
                    guard let cities = cities else {
                        completion(false, .dataNotCompliant)
                        return
                    }
                    guard cities.results.count > 0 else {
                        completion(false, .noCities)
                        return
                    }
                    self.createListCities(type: cities)
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
//    ne prendre que si lastUpdated = date du jour
//    faire test sur pays FR et US afin de prendre la ville dans locationsssss
//    autres pays ville = locations et quartier de la ville = locationssss

    private func createListCities(type: Cities) {
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let currentDateCompare = formatter.string(from: date)
//        ListCitiesService.shared.removeAll()
        do {
            for indice in 0...type.results.count-1 {
//                where type.results[indice].lastUpdated.hasPrefix(currentDateCompare) {
                for indiceLocation in 0...type.results[indice].locations.count-1
                    where type.results[indice].locations[indiceLocation] == type.results[indice].location {
                        let listCities = ListCitie(
                            ident: type.results[indice].ident,
                            country: type.results[indice].country,
                            city: type.results[indice].city,
                            cities: type.results[indice].cities,
                            location: type.results[indice].location,
                            locations: type.results[indice].locations
                        )
//                        print("\(type.results[indice].location)")
                        ListCitiesService.shared.add(listCitie: listCities)
                }
            }
            //        } catch {
            //            print(error)
        }
    }

    /// function createCitiesObjectWith
    /// using JSONDecoder and structure Countries in order to deparse JSON recceived
    ///
    private func createCitiesObjectWith(json: Data, completion: @escaping (_ data: Cities?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let cities = try decoder.decode(Cities.self, from: json)
            return completion(cities)
        } catch _ {
            return completion(nil)
        }
    }
}
