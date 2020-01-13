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

        var color: UIColor

        qualityName.text = cityFavorite.qualityName
        qualityIndicator.text = String(format: "%.0f", cityFavorite.qualityIndicator)
        cityName.text = cityFavorite.city
        department.text = cityFavorite.location
        pollutant.text = cityFavorite.pollutant
        hourLastUpdated.text = cityFavorite.hourLastUpdated

        switch cityFavorite.qualityColor {
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
        qualityName.layer.backgroundColor = color.cgColor
        qualityImage.layer.backgroundColor = color.cgColor
        qualityIndicator.layer.backgroundColor = color.cgColor
    }
}
