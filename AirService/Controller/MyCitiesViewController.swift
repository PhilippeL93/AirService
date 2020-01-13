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

//    var latestMeasure: ListLatestMeasure
//    var measures = ListLatestMeasuresService.shared.listLatestMeasures

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
//            guard let citiesFavorite = citiesFavorite?[indexPath.row] else {
//                return UITableViewCell()
//            }
//            guard let
//                cityFavorite = ListLatestMeasuresService.shared.listLatestMeasures[indexPath.row]
//            else {
//                return UITableViewCell()
//            }
//            ListLatestMeasuresService.shared.listLatestMeasures.count

//            var latestMeasure: ListLatestMeasure
//            for indice in 0...ListLatestMeasuresService.shared.listLatestMeasures.count-1
//                where citiesFavorite.city == ListLatestMeasuresService.shared.listLatestMeasures[indice].city &&
//                    citiesFavorite.location == ListLatestMeasuresService.shared.listLatestMeasures[indice].location {
//                        latestMeasure = ListLatestMeasuresService.shared.listLatestMeasures[indice]
//                        prepareDataForCell(citiesFavorite: citiesFavorite, latestMeasure: latestMeasure)
            cell.configure(with: ListLatestMeasuresService.shared.listLatestMeasures[indexPath.row])
            return cell
//            }
//            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return citiesFavorite?.count ?? 0
        return ListLatestMeasuresService.shared.listLatestMeasures.count
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
            citiesFavorite?.remove(at: indexPath.row)
            ListLatestMeasuresService.shared.removeFavorite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "cityDetail")
            as? CityDetailViewController else {
                return
        }
//        destVC.recipes = ListRecipeService.shared.listRecipes
//        destVC.selectedRecipe = indexPath.item
        show(destVC, sender: self)
    }
}
