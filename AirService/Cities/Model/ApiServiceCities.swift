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
    let settings = Settings()

    var duplicateFound: Bool = false
    var locationsFound: String = ""
    var favorite: Bool = false

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
    ///     - test if reason = explicitlyCancelled
    ///         - no return
    ///     - else
    ///         - no internet connection
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
        parameters = "country=" + countryToSearch + "&limit=9999" + "&activationDate=" +
            currentDate + "&activationDate="  + currentDate + "&" + typeOfSearch + "="
            + cityToSearch

        url = api + parameters

        urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url

        if typeOfSearch == "location[]" {
            ListCitiesService.shared.removeAll()
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
            case .failure(let reason):
                switch reason {
                case .explicitlyCancelled:
                    print("explicitly Cancelled")
                default:
                    completion(false, .noInternetConnection)
                }
        }
        }
    }

    /// function createListCountries
    ///     - loop in order to create listCountries contening contries found
    ///         - depending on country

    private func createListCities(type: Cities, typeOfSearch: String) {
        let date = Date()
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "yyyy-MM"
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

    /// function getFRValues in order to prepare data for French country
    ///  - call function getFavorite in order to display if city already in favorites
    ///  - call function searchDuplicateCity in order to suppress duplicate in API
    ///  - if no duplicate
    ///     - call function haveCharCountry in order to have locationName
    ///     - if location found not empty
    ///         - add entry found in list of cities
    ///
    private func getFRValues(type: ResultsDataCities) {
        favorite = getFavorite(ident: type.ident)

        duplicateFound = searchDuplicateCity(ident: type.ident)

        if duplicateFound == false {
            haveCharCountry(location: type.location, country: type.country, locations: type.locations)
            if !locationsFound.isEmpty {
                let listCities = ListCitie(
                    ident: type.ident,
                    country: type.country,
                    city: type.city,
                    location: type.location,
                    locations: locationsFound,
                    favorite: favorite
                )
                ListCitiesService.shared.add(listCitie: listCities)
            }
        }
    }

    /// function getFRValues in order to prepare data for German country
    ///  - call function getFavorite in order to display if city already in favorites
    ///  - call function searchDuplicateCity in order to suppress duplicate in API
    ///  - if no duplicate
    ///     - call function haveCharCountry in order to have locationName
    ///     - add entry found in list of cities
    ///
    private func getDEValues(type: ResultsDataCities) {
        favorite = getFavorite(ident: type.ident)

        duplicateFound = searchDuplicateCity(ident: type.ident)

        if duplicateFound == false {
            haveCharCountry(location: type.location, country: type.country, locations: type.locations)
            let listCities = ListCitie(
                ident: type.ident,
                country: type.country,
                city: type.city,
                location: type.location,
                locations: locationsFound,
                favorite: favorite
            )
            ListCitiesService.shared.add(listCitie: listCities)
        }
    }

    /// function getFRValues in order to prepare data for other countries
    ///  - call function getFavorite in order to display if city already in favorites
    ///  - call function searchDuplicateCity in order to suppress duplicate in API
    ///  - if no duplicate
    ///     - add entry found in list of cities
    ///
    private func getValues(type: ResultsDataCities) {
        favorite = getFavorite(ident: type.ident)

        duplicateFound = searchDuplicateCity(ident: type.ident)

        if duplicateFound == false {
            let listCities = ListCitie(
                ident: type.ident,
                country: type.country,
                city: type.city,
                location: type.location,
                locations: type.location,
                favorite: favorite
            )
            ListCitiesService.shared.add(listCitie: listCities)
        }
    }

    /// function getFavorite in order to verify if entry already existing in list of cities
    ///  - verify that citiesFavorite is not empty
    ///  - call function getFavorite in order to display if city already in favorites
    ///  - call function searchDuplicateCity in order to suppress duplicate in API
    ///  - if  entry found
    ///     - return true (entry already existing)
    ///   - else
    ///     - return false (entry not existing)
    ///
    private func getFavorite(ident: String) -> Bool {
        guard let citiesFavorite = settings.favoriteCitiesList as [CitiesFavorite]? else {
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

    /// function haveCharCountry in order to determine where we have a good name of location
    ///  - call function containsOnlyLetters in order to verify if location begins with ISO country code or not
    ///  - if location begin with ISO country code
    ///     - search location name in locations not equal to location
    ///  - else
    ///     - search location name in locations equal to location
    ///
    private func haveCharCountry(location: String, country: String, locations: [String] ) {
        let haveChar = containsOnlyLetters(location: location, charToCheck: country)
        switch haveChar {
        case true:
            for indiceLocation in 0...locations.count-1
                where locations[indiceLocation] != location {
                    locationsFound = locations[indiceLocation]
            }
        case false:
            for indiceLocation in 0...locations.count-1
                where locations[indiceLocation] == location {
                    locationsFound = locations[indiceLocation]
            }
        }
    }

    /// function searchDuplicateCity in order to verify duplicate in list of cities
    ///  - if duplicate found
    ///     - return true (duplicate existing)
    ///  - else
    ///     - return false (no duplicate existing)
    ///
    private func searchDuplicateCity(ident: String) -> Bool {
        if ListCitiesService.shared.listCities.count > 0 {
            for indiceDuplicate in 0...ListCitiesService.shared.listCities.count-1
                where
                ident == ListCitiesService.shared.listCities[indiceDuplicate].ident {
                    return true
            }
        }
        return false
    }

    /// function containsOnlyLetters in order to verify presence of characters in two first characters of a string
    ///  - if characters found
    ///     - return true
    ///  - else
    ///     - return false
    ///
    private func containsOnlyLetters(location: String, charToCheck: String) -> Bool {
        let char = String(location[0 ..< 2])

        if char == charToCheck {
            return true
        } else {
            return false
        }
    }
}
