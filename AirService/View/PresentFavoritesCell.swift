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
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 3:
            color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 4:
            color = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case 5:
            color = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case 6:
            color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 7:
            color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        case 8:
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 9:
            color = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        default:
            print("erreur")
        }
        qualityName.backgroundColor = color
        qualityImage.layer.backgroundColor = color.cgColor
        qualityIndicator.backgroundColor = color
    }
}
