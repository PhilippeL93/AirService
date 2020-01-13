//
//  ApiServiceCities.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

//extension String {
//
//  var length: Int {
//    return count
//  }
//
//  subscript (indice: Int) -> String {
//    return self[indice ..< indice + 1]
//  }
//
//  func substring(fromIndex: Int) -> String {
//    return self[min(fromIndex, length) ..< length]
//  }
//
//  func substring(toIndex: Int) -> String {
//    return self[0 ..< max(0, toIndex)]
//  }
//
//  subscript (rangeToExamine: Range<Int>) -> String {
//    let range = Range(uncheckedBounds: (lower: max(0, min(length, rangeToExamine.lowerBound)),
//                                        upper: min(length, max(0, rangeToExamine.upperBound))))
//    let start = index(startIndex, offsetBy: range.lowerBound)
//    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//    return String(self[start ..< end])
//  }
//
//}

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

        if typeOfSearch == "location[]" {
            ListCitiesService.shared.removeAll()
//            request?.cancel()
        }
        request?.cancel()

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
                    self.createListCities(type: cities, typeOfSearch: typeOfSearch)
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

    private func createListCities(type: Cities, typeOfSearch: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateCompare = formatter.string(from: date)

        do {
            for indice in 0...type.results.count-1
                where type.results[indice].lastUpdated.hasPrefix(currentDateCompare) {

                switch type.results[indice].country {
                case "FR":
                    getFRValues(type: type.results[indice])
                case "DE":
                    getDEValues(type: type.results[indice])
                default:
                    getValues(type: type.results[indice])
                }
            }
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

    private func getFavorite(ident: String) -> Bool {
        guard let citiesFavorite = SettingsService.favoriteCitiesList as [CitiesFavorite]? else {
            return false
        }

        if citiesFavorite.count >= 1 {
            for indiceFavorite in 0...citiesFavorite.count-1
                where ident == citiesFavorite[indiceFavorite].ident {
                    return true
            }
        }
        return false
    }

    private func getFRValues(type: ResultsDataCities) {

        var duplicateFound: Bool = false
        var locations: String = ""
        var favorite: Bool = false

        let testChar = containsOnlyLetters(location: type.location, charToCheck: type.country)
        favorite = getFavorite(ident: type.ident)

        duplicateFound = false
        if ListCitiesService.shared.listCities.count > 0 {
            for indiceDuplicate in 0...ListCitiesService.shared.listCities.count-1
                where type.ident ==
                    ListCitiesService.shared.listCities[indiceDuplicate].ident {
                        duplicateFound = true
            }
        }

        if duplicateFound == false {
            switch testChar {
            case true:
                for indiceLocation in 0...type.locations.count-1
                    where type.locations[indiceLocation] != type.location {
                        locations = type.locations[indiceLocation]
                }
            case false:
                for indiceLocation in 0...type.locations.count-1
                    where type.locations[indiceLocation] == type.location {
                        locations = type.locations[indiceLocation]
                }
            }
            if !locations.isEmpty {
                let listCities = ListCitie(
                    ident: type.ident,
                    country: type.country,
                    city: type.city,
                    location: type.location,
                    locations: locations,
                    favorite: favorite
                    //                source: typeOfSearch
                )
                ListCitiesService.shared.add(listCitie: listCities)
            }
        }
    }

    private func getDEValues(type: ResultsDataCities) {

        var duplicateFound: Bool = false
        var locations: String = ""
        var favorite: Bool = false

        let testChar = containsOnlyLetters(location: type.location, charToCheck: type.country)
        favorite = getFavorite(ident: type.ident)

        duplicateFound = false
        if ListCitiesService.shared.listCities.count > 0 {
            for indiceDuplicate in 0...ListCitiesService.shared.listCities.count-1
                where type.ident ==
                    ListCitiesService.shared.listCities[indiceDuplicate].ident {
                        duplicateFound = true
            }
        }

        if duplicateFound == false {
            switch testChar {
            case true:
                for indiceLocation in 0...type.locations.count-1
                    where type.locations[indiceLocation] != type.location {
                        locations = type.locations[indiceLocation]
                }
            case false:
                for indiceLocation in 0...type.locations.count-1
                    where type.locations[indiceLocation] == type.location {
                        locations = type.locations[indiceLocation]
                }
            }
            let listCities = ListCitie(
                ident: type.ident,
                country: type.country,
                city: type.city,
                location: type.location,
                locations: locations,
                favorite: favorite
//                source: typeOfSearch
            )
            ListCitiesService.shared.add(listCitie: listCities)
        }
    }

    private func getValues(type: ResultsDataCities) {

        var duplicateFound: Bool = false
        var favorite: Bool = false

        favorite = getFavorite(ident: type.ident)

        duplicateFound = false
        if ListCitiesService.shared.listCities.count > 0 {
            for indiceDuplicate in 0...ListCitiesService.shared.listCities.count-1
                where type.ident ==
                    ListCitiesService.shared.listCities[indiceDuplicate].ident {
                        duplicateFound = true
            }
        }

        if duplicateFound == false {
            let listCities = ListCitie(
                ident: type.ident,
                country: type.country,
                city: type.city,
                location: type.location,
                locations: type.location,
                favorite: favorite
                //                source: typeOfSearch
            )
            ListCitiesService.shared.add(listCitie: listCities)
        }
    }

    private func containsOnlyLetters(location: String, charToCheck: String) -> Bool {
        let char = String(location[0 ..< 2])

        if char == charToCheck {
            return true
        } else {
            return false
        }
    }
}
