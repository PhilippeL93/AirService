//
//  CitiesViewController.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping
         (_ isoCountryCode: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.isoCountryCode, $1)
        }
    }
}

class CitiesViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
        self.searchBar.delegate = self
    }

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func settingCountry(_ sender: Any) {
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }

    var locationManager = CLLocationManager()
    var cities = ListCitiesService.shared.listCities
    var measures = ListLatestMeasuresService.shared.listLatestMeasures
    var searchActive: Bool = false
    var filtered: [String] = []
    var isoCountryCodeToSearch = ""
    var errorsLocation: Errors?

    private let apiFetchCities = ApiServiceCities()
    private let apiFetchMeasures = ApiServiceLatestMeasures()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let userLocation = locations[0]
        let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude)
        location.fetchCityAndCountry { isoCountryCode, error in
            guard let isoCountryCode = isoCountryCode,
                error == nil else { return }
            self.isoCountryCodeToSearch = isoCountryCode
        }
    }
}

// MARK: - extension Delegate for searchBar
extension CitiesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
//        cities.removeAll()
        self.tableView.reloadData()
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count <= 2 {
            searchActive = false
            self.cities.removeAll()
            self.tableView.reloadData()
        } else {
            self.apiFetchCities.getApiCities(countryToSearch: isoCountryCodeToSearch,
                                             cityToSearch: searchText,
                                             typeOfSearch: "location[]") { (success, errors ) in
                DispatchQueue.main.async {
                    if success {
                        self.apiFetchCities.getApiCities(countryToSearch: self.isoCountryCodeToSearch,
                                                         cityToSearch: searchText,
                                                         typeOfSearch: "city") { (success, errors ) in
                            DispatchQueue.main.async {
                                if success {
                                    } else {
                                    guard let errors = errors else {
                                        return }
                                        self.getErrors(type: errors)
                                        }
                            }
                            self.cities = ListCitiesService.shared.listCities
                            self.tableView.reloadData()
                        }
                    } else {
                        self.errorsLocation = errors
                        print("errorsLocation ========== \(String(describing: self.errorsLocation))")
                        self.apiFetchCities.getApiCities(countryToSearch: self.isoCountryCodeToSearch,
                                                                     cityToSearch: searchText,
                                                                     typeOfSearch: "city") { (success, errors ) in
                            DispatchQueue.main.async {
                                if success {
                                    } else {
                                    guard let errors = errors else {
                                        return }
                                        self.getErrors(type: errors)
                                        }
                                    }
                            self.cities = ListCitiesService.shared.listCities
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            if(filtered.count == 0) {
                searchActive = false
            } else {
                searchActive = true
            }
            self.tableView.reloadData()
        }
    }

}

// MARK: - extension Data for tableView
extension CitiesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCitiesCell", for: indexPath)
            as? PresentCitiesCell else {
                return UITableViewCell()
        }
        var city: String = ""

        switch cities[indexPath.row].country {
        case "FR":
            for indiceLocation in 0...cities[indexPath.row].locations.count-1
                where cities[indexPath.row].locations[indiceLocation] != cities[indexPath.row].location {
                    city = cities[indexPath.row].locations[indiceLocation]  + ", " +
                        cities[indexPath.row].city
            }
            if city.isEmpty {
                city = cities[indexPath.row].city
            }
        case "US":
            city = cities[indexPath.row].city + ", " +
                cities[indexPath.row].location
        default:
            city = cities[indexPath.row].city
        }

        cell.configure(with: city)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}
