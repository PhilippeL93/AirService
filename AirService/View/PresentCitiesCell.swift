//
//  PresentCitiesCell.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

class PresentCitiesCell: UITableViewCell {

    @IBOutlet weak var citiesLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!

    @IBAction func favoriteButton(_ sender: Any) {
        favoriteButton.tintColor = #colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1)
    }

    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - function
    ///   function configure in order to display data in custom cell
    ///
    func configure(with city: String, location: String) {

        citiesLabel.text = city
        locationLabel.text = location
        favoriteButton.tintColor = nil
    }

    // MARK: - layout
    ///   in order to prepare a colored strate
    ///
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.7, 1]
        return layer
    }()

    ///  func viewDidLayoutSubviews
    ///  - in order to put colored strate at the bottom of the cells
    ///
    override func layoutSubviews() {
        gradientLayer.frame = citiesLabel.bounds
        citiesLabel.layer.addSublayer(gradientLayer)
    }
}
