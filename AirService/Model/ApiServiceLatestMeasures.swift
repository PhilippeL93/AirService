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

    private let apiServiceUrl = "https://api.openaq.org/v1/latest?"
    let settingsService = SettingsService()

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
    func getApiLatestMeasures(countryToSearch: String, locationToSearch: String,
                              cityToSearch: String, completion: @escaping
        (Bool, Errors?) -> Void) {

        let queryParams: [String: String] = [
            "limit": "9999",
            "country": countryToSearch,
            "location": locationToSearch,
            "city": cityToSearch
        ]
        let api = apiServiceUrl
        guard let url = URL(string: api)?.appendParameters(params: queryParams)
            else { return completion(false, .noURL) }
//        print("url ==================   \(url)")
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
        do {
            for indice in 0...type.results.count-1 {
                let measureFavorites = calculateIndice(latestMeasure: type.results[indice].measurements)
                let locations = getFavorite(city: type.results[indice].city, location: type.results[indice].location)
                let listLatestMeasures = ListLatestMeasure(
                    country: type.results[indice].country,
                    city: type.results[indice].city,
                    location: type.results[indice].location,
                    locations: locations,
                    qualityIndice: measureFavorites.qualityIndice,
                    qualityIndicator: measureFavorites.qualityIndicator,
                    qualityName: measureFavorites.qualityName,
                    qualityColor: measureFavorites.qualityColor,
                    pollutant: measureFavorites.pollutant,
                    hourLastUpdated: measureFavorites.hourLastUpdated,
                    sourceName: measureFavorites.sourceName,
                    measurements: type.results[indice].measurements
                )
                    ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasures)
            }
        }
//        print("ListLatestMeasuresService.shared \(ListLatestMeasuresService.shared.listLatestMeasures)")
    }

    private func getFavorite(city: String, location: String) -> String {
        guard let citiesFavorite = settingsService.favoriteCitiesList as [CitiesFavorite]? else {
            return ""
        }
        if citiesFavorite.count >= 1 {
            for indiceFavorite in 0...citiesFavorite.count-1
                where city == citiesFavorite[indiceFavorite].city &&
                location == citiesFavorite[indiceFavorite].location {
                    return citiesFavorite[indiceFavorite].locations
            }
        }
        return ""
    }

    private func createMeasurementsObjectWith(json: Data, completion: @escaping (_ data: LatestMeasures?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let latestMeasures = try decoder.decode(LatestMeasures.self, from: json)
            return completion(latestMeasures)
        } catch _ {
            return completion(nil)
        }
    }
    private func calculateIndice(latestMeasure: [MeasuresDetail]) -> MeasuresFavorite {

        var qualityIndicator: Double = 0
        var qualityName: String = ""
        var qualityColor: String = ""
        var indices: IndicesMax

        indices = calculateIndiceAtmoMax(latestMeasure: latestMeasure)

        for indice in 0...QualityLevel.list.count-1
            where indices.indiceAtmoMax == QualityLevel.list[indice].indice {
                qualityName = QualityLevel.list[indice].name
                qualityIndicator = Double(QualityLevel.list[indice].level
                    * latestMeasure[indices.indiceMax].value / indices.valueAtmoMax)
                if latestMeasure[indices.indiceMax].unit == "ppm" {
                    qualityIndicator *= 1000
                }
                qualityColor = QualityLevel.list[indice].color
        }
        let measuresFavorite = MeasuresFavorite(
            qualityName: qualityName,
            qualityColor: qualityColor,
            qualityIndice: indices.indiceAtmoMax,
            qualityIndicator: qualityIndicator,
            pollutant: latestMeasure[indices.indiceMax].parameter,
            hourLastUpdated: latestMeasure[indices.indiceMax].lastUpdated,
            sourceName: latestMeasure[indices.indiceMax].sourceName)
        return measuresFavorite
    }

    private func calculateIndiceAtmoMax(latestMeasure: [MeasuresDetail]) -> (IndicesMax) {
        var indiceMax: Int = 0
        var indiceAtmoMax: Int = 0
        var indiceAtmo: Int = 0
        var valueAtmoMax: Double = 0
        var valueAtmo: Double = 0

        indiceAtmoMax = 0
        indiceMax = 0
        for indice in 0...latestMeasure.count-1 {
            var valueToCheck = latestMeasure[indice].value
            if latestMeasure[indice].unit == "ppm" {
                valueToCheck *= 1000
            }
            switch latestMeasure[indice].parameter {
            case "co":
                (indiceAtmo, valueAtmo) = searchIndicePollutantCO(value: valueToCheck)
            case "no2":
                (indiceAtmo, valueAtmo) = searchIndicePollutantNO(value: valueToCheck)
            case "o3":
                (indiceAtmo, valueAtmo) = searchIndicePollutantO(value: valueToCheck)
            case "pm10":
                (indiceAtmo, valueAtmo) = searchIndicePollutantPMTen(value: valueToCheck)
            case "pm25":
                (indiceAtmo, valueAtmo) = searchIndicePollutantPMTwoFive(value: valueToCheck)
            case "so2":
                (indiceAtmo, valueAtmo) = searchIndicePollutantSO(value: valueToCheck)
            default:
                indiceAtmo = 0
                valueAtmo = 1
            }
            if indiceAtmo > indiceAtmoMax {
                indiceAtmoMax = indiceAtmo
                indiceMax = indice
                valueAtmoMax = valueAtmo
            }
        }
        let indices = IndicesMax(indiceAtmoMax: indiceAtmoMax, indiceMax: indiceMax, valueAtmoMax: valueAtmoMax)
        return indices
    }
    private func searchIndicePollutantCO(value: Double) -> (Int, Double) {
        for indice in 0...CarbonMonoxide.list.count-1
            where value <= CarbonMonoxide.list[indice].value {
                return (CarbonMonoxide.list[indice].indice, CarbonMonoxide.list[indice].value)
        }
        return (0, 0)
    }

    private func searchIndicePollutantNO(value: Double) -> (Int, Double) {
        for indice in 0...NitrogenDioxide.list.count-1
            where value <= NitrogenDioxide.list[indice].value {
                return (NitrogenDioxide.list[indice].indice, NitrogenDioxide.list[indice].value)
        }
        return (0, 0)
    }

    private func searchIndicePollutantO(value: Double) -> (Int, Double) {
        for indice in 0...Ozone.list.count-1
            where value <= Ozone.list[indice].value {
                return (Ozone.list[indice].indice, Ozone.list[indice].value)
        }
        return (0, 0)
    }

    private func searchIndicePollutantPMTen(value: Double) -> (Int, Double) {
        for indice in 0...ParticulateTen.list.count-1
            where value <= ParticulateTen.list[indice].value {
                return (ParticulateTen.list[indice].indice, ParticulateTen.list[indice].value)
        }
        return (0, 0)
    }

    private func searchIndicePollutantPMTwoFive(value: Double) -> (Int, Double) {
        for indice in 0...ParticulateTwoFive.list.count-1
            where value <= ParticulateTwoFive.list[indice].value {
                return (ParticulateTwoFive.list[indice].indice, ParticulateTwoFive.list[indice].value)
        }
        return (0, 0)
    }

    private func searchIndicePollutantSO(value: Double) -> (Int, Double) {
        for indice in 0...SulfurDioxide.list.count-1
            where value <= SulfurDioxide.list[indice].value {
                return (SulfurDioxide.list[indice].indice, SulfurDioxide.list[indice].value)
        }
        return (0, 0)
    }
}
