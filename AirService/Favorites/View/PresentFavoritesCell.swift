//
//  PresentFavoritesCell.swift
//  AirService
//
//  Created by Philippe on 09/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

// MARK: class PresentFavoritesCell
class PresentFavoritesCell: UITableViewCell {

    // MARK: - outlets
    ///   link between view elements and controller
    @IBOutlet weak var qualityName: UITextField!
    @IBOutlet weak var qualityIndicator: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var pollutant: UITextField!
    @IBOutlet weak var hourLastUpdated: UITextField!
    @IBOutlet weak var qualityView: UIView!

    let checkCountry = CheckCountry()

    ///   configure in order to display data in custom cell
    func configure(with cityFavorite: ListLatestMeasure) {

        let cityFavorite = cityFavorite

        qualityName.text = cityFavorite.qualityName
        qualityIndicator.text = String(format: "%.0f", cityFavorite.qualityIndicator)
        cityName.text = cityFavorite.city

        pollutant.text = cityFavorite.pollutant

        let typeCountry = checkCountry.checkCountry(country: cityFavorite.country)
        switch typeCountry {
        case "countryTypeOne":
            department.text = cityFavorite.city
            cityName.text = cityFavorite.locations
        case "countryTypeTwo":
            department.text = cityFavorite.locations
        default:
            department.text = cityFavorite.location
        }

        let color = UIColor(named: String(cityFavorite.qualityColor)) ?? .white
        qualityName.backgroundColor = color
        qualityIndicator.backgroundColor = color
        qualityView.backgroundColor = color

        hourLastUpdated.text = " \(String(cityFavorite.hourLastUpdated[0 ..< 10]))" +
                                " à : \(String(cityFavorite.hourLastUpdated[11 ..< 19]))"
    }

}
