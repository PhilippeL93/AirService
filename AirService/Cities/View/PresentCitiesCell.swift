//
//  PresentCitiesCell.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

// MARK: class PresentCitiesCell
class PresentCitiesCell: UITableViewCell {

    // MARK: - outlets
    ///   link between view elements and controller
    @IBOutlet weak var citiesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func manageFavoriteButton(_ sender: Any) {
        manageFavorite()
    }

    // MARK: - variables
    /// - cities : contains list of cities found
    /// - citiesFavorite : contains list of cities in favorite
    /// - settingsService : in order to access at userDefaults
    var cities = ListCitiesService.shared.listCities
    var citiesFavorite: [CitiesFavorite]?
    let settings = Settings()

    // MARK: - functions
    ///   manageFavorite in order manage add or remove city in favorite
    ///   - if  favorite
    ///      - suppressFavorite in order to suppress favorite
    ///   - else
    ///     - addNewFavorite in order to add to favorite
    func manageFavorite() {
        citiesFavorite = settings.favoriteCitiesList
        cities = ListCitiesService.shared.listCities
        if favoriteButton.currentTitleColor == #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
            favoriteButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
            suppressFavorite()
        } else {
            favoriteButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            addNewFavorite()
            settings.favoriteCitiesList = (citiesFavorite ?? [])
            citiesFavorite = settings.favoriteCitiesList
        }
    }

    ///   addNewFavorite in order to add  city in favorite
    private func addNewFavorite() {
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
    }

    ///   suppressFavorite in order suppress city from favorite
    private func suppressFavorite() {
        guard let countOfFavorites = citiesFavorite?.count else {
            return
        }
        for indice in 0...countOfFavorites-1
            where (citiesFavorite?[indice].city == citiesLabel.text
                && citiesFavorite?[indice].location == locationLabel.text )
                || (citiesFavorite?[indice].locations == citiesLabel.text
                && citiesFavorite?[indice].city == locationLabel.text) {
                citiesFavorite?.remove(at: indice)
                settings.favoriteCitiesList = (citiesFavorite ?? [])
                return
        }
    }

    ///   configure in order to display data in custom cell
    func configure(with country: String, city: String, location: String, favorite: Bool) {
        citiesLabel.text = city
        locationLabel.text = location
        if country == "FR" {
            locationLabel.text = city
            citiesLabel.text = location
        }
        favoriteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        favoriteButton.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        if favorite == true {
            favoriteButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        } else {
            favoriteButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
    }
}
