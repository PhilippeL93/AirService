//
//  MyCitiesViewController.swift
//  AirService
//
//  Created by Philippe on 09/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

class MyCitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tagLatestMeasure = false
        ListLatestMeasuresService.shared.removeAll()
        citiesFavorite = settings.favoriteCitiesList

        guard let countOfFavorites = citiesFavorite?.count, countOfFavorites > 0 else {
            return
        }
        for indice in 0...countOfFavorites-1 {
            guard let country = citiesFavorite?[indice].country ,
                let location = citiesFavorite?[indice].location ,
                let city = citiesFavorite?[indice].city else {
                    return
            }
            searchLatestMeasures(countryToSearch: country,
                                 locationToSearch: location,
                                 cityToSearch: city)
        }
    }

    var citiesFavorite: [CitiesFavorite]?
    var tagLatestMeasure: Bool = false
    var cityFavorite: [LatestMeasures] = []
    let settings = Settings()

    private let apiFetchMeasures = ApiServiceLatestMeasures()

    private func searchLatestMeasures(countryToSearch: String, locationToSearch: String, cityToSearch: String) {
        self.apiFetchMeasures.getApiLatestMeasures(
            countryToSearch: countryToSearch,
            locationToSearch: locationToSearch,
            cityToSearch: cityToSearch
        ) { (success, errors) in
            DispatchQueue.main.async {
                if success {
                    self.getAllMeasures()
                } else {
                    guard let errors = errors else {
                        return }
                    self.getErrors(type: errors)
                }
            }
        }
    }

    private func getAllMeasures() {
        if ListLatestMeasuresService.shared.listLatestMeasures.count ==
            self.citiesFavorite?.count {
            self.tagLatestMeasure = true
            self.citiesFavorite = settings.favoriteCitiesList
            self.tableView.reloadData()
        }
    }

    private func deleteFavorite(city: String, location: String) {
        for indice in 0...ListLatestMeasuresService.shared.listLatestMeasures.count-1
            where city ==
                ListLatestMeasuresService.shared.listLatestMeasures[indice].city &&
                location ==
                ListLatestMeasuresService.shared.listLatestMeasures[indice].location {
                    ListLatestMeasuresService.shared.removeFavorite(at: indice)
                    return
        }
    }
}

// MARK: - extension Data for tableView
extension MyCitiesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tagLatestMeasure {
        case false:
            return UITableViewCell()
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFavoritesCell", for: indexPath)
                as? PresentFavoritesCell else {
                    return UITableViewCell()
            }
            var indiceCity: Int = 0
            for indice in 0...ListLatestMeasuresService.shared.listLatestMeasures.count-1
                where citiesFavorite?[indexPath.row].city ==
                    ListLatestMeasuresService.shared.listLatestMeasures[indice].city &&
                    citiesFavorite?[indexPath.row].location ==
                    ListLatestMeasuresService.shared.listLatestMeasures[indice].location {
                        indiceCity = indice
            }
            cell.configure(with: ListLatestMeasuresService.shared.listLatestMeasures[indiceCity])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesFavorite?.count ?? 0
    }
}

// MARK: - extension Delegate
extension MyCitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 3
        return size
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let city = citiesFavorite?[indexPath.row].city,
                let location = citiesFavorite?[indexPath.row].location else {
                return
            }
            deleteFavorite(city: city, location: location)
            citiesFavorite?.remove(at: indexPath.row)
            settings.favoriteCitiesList = (citiesFavorite ?? [])!
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indiceCity: Int = 0
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "cityDetail")
            as? CityDetailViewController else {
                return
        }
        for indice in 0...ListLatestMeasuresService.shared.listLatestMeasures.count-1
            where citiesFavorite?[indexPath.row].city ==
                ListLatestMeasuresService.shared.listLatestMeasures[indice].city &&
            citiesFavorite?[indexPath.row].location ==
                ListLatestMeasuresService.shared.listLatestMeasures[indice].location {
            indiceCity = indice
        }
        destVC.cityDetail = [ListLatestMeasuresService.shared.listLatestMeasures[indiceCity]]
        show(destVC, sender: self)
    }
}
