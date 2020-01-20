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

    @IBOutlet weak var favoriteButton: UIButton!

    @IBAction func manageFavoriteButton(_ sender: Any) {
        manageFavorite()
    }

    var cities = ListCitiesService.shared.listCities
    var citiesFavorite: [CitiesFavorite]?
    let settingsService = SettingsService()

    // MARK: - function

    func manageFavorite() {
        citiesFavorite = settingsService.favoriteCitiesList
        cities = ListCitiesService.shared.listCities
        if favoriteButton.currentTitleColor == #colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1) {
            favoriteButton.setTitleColor(.white, for: .normal)

            guard let countOfFavorites = citiesFavorite?.count else {
                return
            }
            for indice in 0...countOfFavorites-1
                where (citiesFavorite?[indice].city == citiesLabel.text
                    && citiesFavorite?[indice].location == locationLabel.text )
                    || (citiesFavorite?[indice].locations == citiesLabel.text
                    && citiesFavorite?[indice].city == locationLabel.text) {
                    citiesFavorite?.remove(at: indice)
                    settingsService.favoriteCitiesList = (citiesFavorite ?? [])!
                    return
            }
        } else {
            for indice in 0...cities.count-1
                where ( cities[indice].city == citiesLabel.text
                    && cities[indice].locations == locationLabel.text )
                    || ( cities[indice].locations == citiesLabel.text
                    && cities[indice].city == locationLabel.text) {
                    let cityFavorite = CitiesFavorite(
                        ident: cities[indice].ident,
                        country: cities[indice].country,
                        city: cities[indice].city,
                        location: cities[indice].location,
                        locations: cities[indice].locations
                    )
                    citiesFavorite?.append(cityFavorite)
            }
            settingsService.favoriteCitiesList = (citiesFavorite ?? [])!
            favoriteButton.setTitleColor(#colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1), for: .normal)
        }
    }
    ///   function configure in order to display data in custom cell
    ///
    func configure(with country: String, city: String, location: String, favorite: Bool) {

        citiesLabel.text = city
        locationLabel.text = location
        if country == "FR" {
            locationLabel.text = city
            citiesLabel.text = location
        }
        if favorite == true {
            favoriteButton.setTitleColor(#colorLiteral(red: 0.2673686743, green: 0.5816780329, blue: 0.3659712374, alpha: 1), for: .normal)
        } else {
            favoriteButton.setTitleColor(.white, for: .normal)
        }
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
