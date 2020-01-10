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

    var measures = ListLatestMeasuresService.shared.listLatestMeasures

    ///   function configure in order to display data in custom cell
    ///
    func configure(with city: String) {

        qualityName.text = "Très bien"
        qualityIndicator.text = "15"
        cityName.text = city
        department.text = "Department"
        pollutant.text = "pollutant"
        hourLastUpdated.text = "heure"
    }
}
