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

//    override func viewDidLoad() {
//        print("viewDidLoad")
//        super.viewDidLoad()
//        tableView.reloadData()
//        KeySelectedIndexes
//    }

    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear")
        super.viewWillAppear(animated)
        tagLatestMeasure = false
        ListLatestMeasuresService.shared.removeAll()
        citiesFavorite = SettingsService.favoriteCitiesList

        guard let countOfFavorites = citiesFavorite?.count else {
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
        tableView.reloadData()
    }

    //    override func viewDidAppear(_ animated: Bool) {
    //
    //        tableView.reloadData()
    //    }

    var citiesFavorite: [CitiesFavorite]?
    var tagLatestMeasure: Bool = false
    var cityFavorite: [LatestMeasures] = []

    private let apiFetchMeasures = ApiServiceLatestMeasures()

    private func searchLatestMeasures(countryToSearch: String, locationToSearch: String, cityToSearch: String) {
        self.apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch,
                                                   locationToSearch: locationToSearch,
                                                   cityToSearch: cityToSearch) { (success, errors ) in
//                                                    DispatchQueue.main.async {
                                                    if success {
                                                        if self.citiesFavorite?.count ==
                                                            ListLatestMeasuresService.shared.listLatestMeasures.count {
                                                            self.tagLatestMeasure = true
                                                            self.citiesFavorite = SettingsService.favoriteCitiesList
                                                            self.tableView.reloadData()
                                                        }
                                                    } else {
                                                        guard let errors = errors else {
                                                            return }
                                                        self.getErrors(type: errors)
                                                    }
//                                                    }
        }
    }

//    private func deleteFavorite(city: String, location: String) {
////        citiesFavorite = SettingsService.favoriteCitiesList
//        guard let countOfFavorites = citiesFavorite?.count else {
//            return
//        }
//        for indice in 0...countOfFavorites-1
//            where citiesFavorite?[indice].city == city
//                && citiesFavorite?[indice].location == location {
//                    citiesFavorite?.remove(at: indice)
//                    SettingsService.favoriteCitiesList = (citiesFavorite ?? [])!
//                    return
//        }
//    }

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

        var indiceCity: Int = 0
        switch tagLatestMeasure {
        case false:
            return UITableViewCell()
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFavoritesCell", for: indexPath)
                as? PresentFavoritesCell else {
                    return UITableViewCell()
            }
            for indice in 0...ListLatestMeasuresService.shared.listLatestMeasures.count-1
                where citiesFavorite?[indexPath.row].city ==
                    ListLatestMeasuresService.shared.listLatestMeasures[indice].city &&
                citiesFavorite?[indexPath.row].location ==
                    ListLatestMeasuresService.shared.listLatestMeasures[indice].location {
                indiceCity = indice
            }
//            cell.configure(with: ListLatestMeasuresService.shared.listLatestMeasures[indexPath.row])
            cell.configure(with: ListLatestMeasuresService.shared.listLatestMeasures[indiceCity])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ListLatestMeasuresService.shared.listLatestMeasures.count
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
//            deleteFavorite(city: ListLatestMeasuresService.shared.listLatestMeasures[indexPath.row].city,
//                           location: ListLatestMeasuresService.shared.listLatestMeasures[indexPath.row].location)
//            ListLatestMeasuresService.shared.removeFavorite(at: indexPath.row)
            guard let city = citiesFavorite?[indexPath.row].city,
                let location = citiesFavorite?[indexPath.row].location else {
                return
            }
            deleteFavorite(city: city, location: location)
            citiesFavorite?.remove(at: indexPath.row)
            SettingsService.favoriteCitiesList = (citiesFavorite ?? [])!
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
//        destVC.cityDetail = [ListLatestMeasuresService.shared.listLatestMeasures[indexPath.item]]
        destVC.cityDetail = [ListLatestMeasuresService.shared.listLatestMeasures[indiceCity]]
        show(destVC, sender: self)
    }
}
