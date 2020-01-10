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

    override func viewDidLoad() {
        super.viewDidLoad()
//        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [String] ?? []
        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [CityFavorite]

        tableView.reloadData()
//        KeySelectedIndexes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [String] ?? []
        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [CityFavorite]
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
//        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [String] ?? []
        favoriteCityList = UserDefaults.standard.object(forKey: "favoriteCity") as? [CityFavorite]
        tableView.reloadData()
    }

//   var favoriteCityList: [String] = []
    var favoriteCityList: [CityFavorite]?
    var measures = ListLatestMeasuresService.shared.listLatestMeasures

    private let apiFetchMeasures = ApiServiceLatestMeasures()

    private func searchLatestMeasures(countryToSearch: String, locationToSearch: String, cityToSearch: String) {
        self.apiFetchMeasures.getApiLatestMeasures(countryToSearch: countryToSearch,
                                                   locationToSearch: locationToSearch,
                                                   cityToSearch: cityToSearch) { (success, errors ) in
                                                    DispatchQueue.main.async {
                                                        if success {
                                                        } else {
                                                            guard let errors = errors else {
                                                                return }
                                                            self.getErrors(type: errors)
                                                        }
                                                    }
        }
    }
}

// MARK: - extension Data for tableView
extension MyCitiesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFavoritesCell", for: indexPath)
            as? PresentFavoritesCell else {
                return UITableViewCell()
        }
        guard let favoriteCityList = favoriteCityList?[indexPath.row] else {
            return UITableViewCell()
        }
        searchLatestMeasures(countryToSearch: favoriteCityList.country,
                             locationToSearch: favoriteCityList.location, cityToSearch: favoriteCityList.city)
        let city = "City"
        cell.configure(with: city)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCityList?.count ?? 0
    }
}
