//
//  ApiServiceLatestMeasures.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - class ApiServiceLatestMeasures
class ApiServiceLatestMeasures {

    private let apiServiceUrl = "https://api.openaq.org/v1/latest?"
    let settings = Settings()
    var indiceMax: Int = 0
    var indiceAtmoMax: Int = 0
    var indiceAtmo: Int = 0
    var valueAtmoMax: Double = 0
    var valueAtmo: Double = 0
    var valueMin: Double = 0
    var valueMax: Double = 0

    // MARK: - functions
    /// getApiLatestMeasures generate a call to API with Alamofire
    /// - preparing var for call
    /// - request of Alamofire (AF.request(url).responseJSON)
    /// - at call return
    /// - switch result = success ok
    ///     - createMeasurementsObjectWith in order to deparse JSON
    ///         - if data like measurements
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - if count of measurements > 0
    ///             - continue
    ///         - else
    ///             - exit of call with completion = false
    ///         - createListMeasurements
    ///         - exit of call with completion = true
    /// - other exit of call with completion = false
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

    /// createListMeasurements
    ///     - loop in order to create ListLatestMeasures contening measures found
    ///     - calculateIndice in order to calculate quality indice
    ///     - getFavorite in order to retrieve locationName
    ///     - add new entry in ListLatestMeasures
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
                    measurements: ListLatestMeasuresDetailService.shared.listLatestMeasuresDetail
                )
                ListLatestMeasuresService.shared.add(listLatestMeasure: listLatestMeasures)
            }
        }
    }

    /// getFavorite in order to retrieve locationName
    ///     - verify that citiesFavorites is not empty
    ///     - loop in order to found locationName
    ///         - if found
    ///             - return locationName
    ///         - else
    ///             - return empty string
    private func getFavorite(city: String, location: String) -> String {
        guard let citiesFavorite = settings.favoriteCitiesList as [CitiesFavorite]? else {
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

    /// createMeasurementsObjectWith
    ///     using JSONDecoder and structure LatestMeasures in order to deparse JSON recceived
    private func createMeasurementsObjectWith(json: Data, completion: @escaping (_ data: LatestMeasures?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let latestMeasures = try decoder.decode(LatestMeasures.self, from: json)
            return completion(latestMeasures)
        } catch _ {
            return completion(nil)
        }
    }

    /// calculateIndice in order to determine worst indice of air quality
    ///  - calculateIndiceAtmoMax in order to determine indices (IndicesMax)
    ///                     contening values of worst indice of air quality
    ///  - loop in order to
    ///     - determine quality level
    ///     - calculate indice
    ///     - transform indice when unit = ppm instead of µg/m³
    ///  - create mesaure with quality indicators
    private func calculateIndice(latestMeasure: [MeasuresDetail]) -> MeasuresFavorite {
        var qualityIndicator: Double = 0
        var qualityName: String = ""
        var qualityColor: String = ""
        var indices: IndicesMax

        ListLatestMeasuresDetailService.shared.removeAll()
        indices = calculateIndiceAtmoMax(latestMeasure: latestMeasure)

        for indice in 0...QualityLevel.list.count-1
            where indices.indiceAtmoMax == QualityLevel.list[indice].indice {
                qualityName = QualityLevel.list[indice].name
                qualityColor = QualityLevel.list[indice].color
                qualityIndicator = Double(QualityLevel.list[indice].level
                    * latestMeasure[indices.indiceMax].value / indices.valueAtmoMax)
                if latestMeasure[indices.indiceMax].unit == "ppm" {
                    qualityIndicator *= 1000
                }
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

    /// calculateIndiceAtmoMax in order determine IndicesMax contening values of worst indice of air quality
    ///  - loop in order to search among measures the worst
    ///     - searchPollutantsValues
    /// - compare previous indice max (indiceAtmoMax) with new indice
    ///     - if new indice > previous indice max
    ///         - new indice = previous indice max
    /// - return indices
    private func calculateIndiceAtmoMax(latestMeasure: [MeasuresDetail]) -> (IndicesMax) {
        indiceMax = 0
        indiceAtmoMax = 0
        indiceAtmo = 0
        valueAtmoMax = 0
        valueAtmo = 0
        valueMin = 0
        valueMax = 0
        for indice in 0...latestMeasure.count-1 {
            var valueToCheck = latestMeasure[indice].value
            if latestMeasure[indice].unit == "ppm" {
                valueToCheck *= 1000
            }
            searchPollutantsValues(valueToCheck: valueToCheck, parameter: latestMeasure[indice].parameter)

            if indiceAtmo > indiceAtmoMax {
                indiceAtmoMax = indiceAtmo
                indiceMax = indice
                valueAtmoMax = valueAtmo
            }
            let listLatestMeasuresDetail = ListLatestMeasuresDetail(
                parameter: latestMeasure[indice].parameter,
                value: latestMeasure[indice].value,
                lastUpdated: latestMeasure[indice].lastUpdated,
                unit: latestMeasure[indice].unit,
                sourceName: latestMeasure[indice].sourceName,
                indiceAtmo: indiceAtmo, valueMin: valueMin, valueMax: valueMax
            )
            ListLatestMeasuresDetailService.shared.add(listLatestMeasureDetail: listLatestMeasuresDetail)
        }
        let indices = IndicesMax(indiceAtmoMax: indiceAtmoMax,
            indiceMax: indiceMax, valueAtmoMax: valueAtmoMax)
        return indices
    }

    /// searchPollutantsValues in order to determine by pollutant
    ///         indice air quality
    ///         value pollutant
    ///         value min pollutant
    ///         value max pollutant
    ///  - switch pollutant type
    ///     - co : Carbon Monoxide
    ///     - no2 : Nitrogen Dioxide
    ///     - o3 : Ozone
    ///     - pm10 : Particulate matter less than 10 micrometers in diameter
    ///     - pm25 : Particulate matter less than 2.5 micrometers in diameter
    ///     - so2 : Sulfur Dioxide
    private func searchPollutantsValues(valueToCheck: Double, parameter: String) {
        switch parameter {
        case "co":
            (indiceAtmo, valueAtmo) = searchIndicePollutantCO(value: valueToCheck)
            valueMin = CarbonMonoxide.list[0].value
            valueMax = CarbonMonoxide.list[7].value * 1.5
        case "no2":
            (indiceAtmo, valueAtmo) = searchIndicePollutantNO(value: valueToCheck)
            valueMin = NitrogenDioxide.list[0].value
            valueMax = NitrogenDioxide.list[7].value * 1.5
        case "o3":
            (indiceAtmo, valueAtmo) = searchIndicePollutantO(value: valueToCheck)
            valueMin = Ozone.list[0].value
            valueMax = Ozone.list[7].value * 1.5
        case "pm10":
            (indiceAtmo, valueAtmo) = searchIndicePollutantPMTen(value: valueToCheck)
            valueMin = ParticulateTen.list[0].value
            valueMax = ParticulateTen.list[7].value * 1.5
        case "pm25":
            (indiceAtmo, valueAtmo) = searchIndicePollutantPMTwoFive(value: valueToCheck)
            valueMin = ParticulateTwoFive.list[0].value
            valueMax = ParticulateTwoFive.list[7].value * 1.5
        case "so2":
            (indiceAtmo, valueAtmo) = searchIndicePollutantSO(value: valueToCheck)
            valueMin = SulfurDioxide.list[0].value
            valueMax = SulfurDioxide.list[7].value * 1.5
        default:
            indiceAtmo = 0
        }
    }

    /// searchIndicePollutantCO in order determine level of Carbon Monoxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantCO(value: Double) -> (Int, Double) {
        for indice in 0...CarbonMonoxide.list.count-1
            where value <= CarbonMonoxide.list[indice].value {
                return (CarbonMonoxide.list[indice].indice, CarbonMonoxide.list[indice].value)
        }
        return (0, 0)
    }

    /// searchIndicePollutantNO in order determine level of Nitrogen Dioxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantNO(value: Double) -> (Int, Double) {
        for indice in 0...NitrogenDioxide.list.count-1
            where value <= NitrogenDioxide.list[indice].value {
                return (NitrogenDioxide.list[indice].indice, NitrogenDioxide.list[indice].value)
        }
        return (0, 0)
    }

    /// searchIndicePollutantO in order determine level of Ozone
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantO(value: Double) -> (Int, Double) {
        for indice in 0...Ozone.list.count-1
            where value <= Ozone.list[indice].value {
                return (Ozone.list[indice].indice, Ozone.list[indice].value)
        }
        return (0, 0)
    }

    /// searchIndicePollutantPMTen in order determine level of PM10
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantPMTen(value: Double) -> (Int, Double) {
        for indice in 0...ParticulateTen.list.count-1
            where value <= ParticulateTen.list[indice].value {
                return (ParticulateTen.list[indice].indice, ParticulateTen.list[indice].value)
        }
        return (0, 0)
    }

    /// searchIndicePollutantPMTwoFive in order determine level of PM2.5
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantPMTwoFive(value: Double) -> (Int, Double) {
        for indice in 0...ParticulateTwoFive.list.count-1
            where value <= ParticulateTwoFive.list[indice].value {
                return (ParticulateTwoFive.list[indice].indice, ParticulateTwoFive.list[indice].value)
        }
        return (0, 0)
    }

    /// searchIndicePollutantSO in order determine level of Sulfur Dioxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    private func searchIndicePollutantSO(value: Double) -> (Int, Double) {
        for indice in 0...SulfurDioxide.list.count-1
            where value <= SulfurDioxide.list[indice].value {
                return (SulfurDioxide.list[indice].indice, SulfurDioxide.list[indice].value)
        }
        return (0, 0)
    }
}
