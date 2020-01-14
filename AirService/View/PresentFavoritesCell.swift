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

    @IBOutlet weak var qualityImage: UIImageView!

    @IBOutlet weak var qualityIndicator: UITextField!

    @IBOutlet weak var cityName: UITextField!

    @IBOutlet weak var department: UITextField!

    @IBOutlet weak var pollutant: UITextField!

    @IBOutlet weak var hourLastUpdated: UITextField!

    ///   function configure in order to display data in custom cell
    ///
    func configure(with cityFavorite: ListLatestMeasure) {

        let cityFavorite = cityFavorite

        qualityName.text = cityFavorite.qualityName
        qualityIndicator.text = String(format: "%.0f", cityFavorite.qualityIndicator)
        cityName.text = cityFavorite.city

        pollutant.text = cityFavorite.pollutant
        hourLastUpdated.text = cityFavorite.hourLastUpdated

        if cityFavorite.country == "FR" || cityFavorite.country == "DE" {
            department.text = cityFavorite.locations
        } else {
            department.text = cityFavorite.location
        }
        setQualityImage(qualityIndice: cityFavorite.qualityIndice)
        setColor(qualityColor: cityFavorite.qualityColor)
    }

    func setQualityImage(qualityIndice: Int) {
        switch qualityIndice {
        case 1, 2:
            qualityImage.image = #imageLiteral(resourceName: "icone_VeryGood.png")
        case 3, 4:
            qualityImage.image = #imageLiteral(resourceName: "icone_Good.png")
        case 5:
            qualityImage.image = #imageLiteral(resourceName: "icone_Medium.png")
        case 6:
            qualityImage.image = #imageLiteral(resourceName: "icone_Poor.png")
        case 7, 8:
            qualityImage.image = #imageLiteral(resourceName: "icone_Bad.png")
        case 9:
            qualityImage.image = #imageLiteral(resourceName: "icone_VeryBad.png")
        default:
            print("")
        }
    }
    private func setColor(qualityColor: String) {
        var color: UIColor
        switch qualityColor {
        case "green" :
            color = UIColor.green
        case "yellow" :
            color = UIColor.yellow
        case "orange" :
            color = UIColor.orange
        case "red" :
            color = UIColor.red
        case "purple" :
            color = UIColor.purple
        default:
            color = UIColor.white
        }
        qualityName.backgroundColor = color
        qualityImage.layer.backgroundColor = color.cgColor
        qualityIndicator.backgroundColor = color
    }
}
