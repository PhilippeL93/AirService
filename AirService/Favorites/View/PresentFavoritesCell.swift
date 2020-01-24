//
//  PresentFavoritesCell.swift
//  AirService
//
//  Created by Philippe on 09/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

class PresentFavoritesCell: UITableViewCell {

    @IBOutlet weak var qualityName: UITextField!
    @IBOutlet weak var qualityIndicator: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var pollutant: UITextField!
    @IBOutlet weak var hourLastUpdated: UITextField!
    @IBOutlet weak var qualityView: UIView!

    ///   function configure in order to display data in custom cell
    ///
    func configure(with cityFavorite: ListLatestMeasure) {

        let cityFavorite = cityFavorite

        qualityName.text = cityFavorite.qualityName
        qualityIndicator.text = String(format: "%.0f", cityFavorite.qualityIndicator)
        cityName.text = cityFavorite.city

        pollutant.text = cityFavorite.pollutant

         if cityFavorite.country == "DE" {
            department.text = cityFavorite.locations
        } else {
            department.text = cityFavorite.location
        }
        if cityFavorite.country == "FR" {
            department.text = cityFavorite.city
            cityName.text = cityFavorite.locations
        }

        setQualityAndColorImage(qualityIndice: cityFavorite.qualityIndice)

        hourLastUpdated.text = " \(String(cityFavorite.hourLastUpdated[0 ..< 10]))" +
                                " à : \(String(cityFavorite.hourLastUpdated[11 ..< 19]))"
    }
    private func setQualityAndColorImage(qualityIndice: Int) {
        var color: UIColor = UIColor.white
        switch qualityIndice {
        case 1:
            color = UIColor(named: "colorLevelOne") ?? .white
        case 2:
            color = UIColor(named: "colorLevelTwo") ?? .white
        case 3:
            color = UIColor(named: "colorLevelThree") ?? .white
        case 4:
            color = UIColor(named: "colorLevelFour") ?? .white
        case 5:
            color = UIColor(named: "colorLevelFive") ?? .white
        case 6:
            color = UIColor(named: "colorLevelSix") ?? .white
        case 7:
            color = UIColor(named: "colorLevelSeven") ?? .white
        case 8:
            color = UIColor(named: "colorLevelEight") ?? .white
        case 9:
            color = UIColor(named: "colorLevelNine") ?? .white
        default:
            color = UIColor(named: "colorLevelDefault") ?? .white
        }
        qualityName.backgroundColor = color
        qualityIndicator.backgroundColor = color
        qualityView.backgroundColor = color
    }
}
