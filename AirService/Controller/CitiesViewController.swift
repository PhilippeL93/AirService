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
         (_ country: String?, _ isoCountryCode: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.country, $0?.first?.isoCountryCode, $1)
        }
    }
}

class CitiesViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var countryLabel: UILabel!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func settingCountry(_ sender: Any) {
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        self.searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settings = segue.destination as? SettingsViewController
        settings?.delegate = self
    }

    var locationManager = CLLocationManager()
    var cities = ListCitiesService.shared.listCities
    var searchActive: Bool = false
    var filtered: [String] = []
    var isoCountryCodeToSearch = ""
    var country = ""
    var errorsLocation: Errors?

    private let apiFetchCities = ApiServiceCities()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let userLocation = locations[0]
        let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude)
        location.fetchCityAndCountry { country, isoCountryCode, error in
            guard let country = country, let isoCountryCode = isoCountryCode,
                error == nil else { return }
            self.isoCountryCodeToSearch = isoCountryCode
            self.country = country
            self.countryLabel.text = country
        }
    }
}

// MARK: - extension Delegate for searchBar
extension CitiesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.cities.removeAll()
        self.tableView.reloadData()
        searchActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= 2 {
            searchActive = false
            self.cities.removeAll()
            self.tableView.reloadData()
        } else {
            self.errorsLocation = nil
            self.apiFetchCities.getApiCities(countryToSearch: isoCountryCodeToSearch,
                                             cityToSearch: searchText,
                                             typeOfSearch: "location[]") { (success, errors ) in
                                                if success {
                                                    self.searchAPIWithCity(searchText: searchText)
                                                } else {
                                                    self.errorsLocation = errors
                                                    self.searchAPIWithCity(searchText: searchText)
                                                }
            }
            if(filtered.count == 0) {
                searchActive = false
            } else {
                searchActive = true
            }
        }
    }

    func searchAPIWithCity(searchText: String) {
        self.apiFetchCities.getApiCities(countryToSearch: self.isoCountryCodeToSearch,
                                         cityToSearch: searchText,
                                         typeOfSearch: "city") { (success, errors ) in
                                            DispatchQueue.main.async {
                                                if success {
                                                    self.cities = ListCitiesService.shared.listCities
                                                    if self.cities.count >= 1 {
                                                        self.tableView.reloadData()
                                                    } else {
                                                        self.getErrors(type: .noCities)
                                                    }
                                                } else {
                                                    if self.errorsLocation == nil {
                                                        self.cities = ListCitiesService.shared.listCities
                                                        if self.cities.count >= 1 {
                                                            self.tableView.reloadData()
                                                        } else {
                                                            self.getErrors(type: .noCities)
                                                        }
                                                    } else {
                                                        guard let errors = errors else {
                                                            return }
                                                        if self.errorsLocation != nil {
                                                            self.getErrors(type: errors)
                                                        }
                                                    }
                                                }
                                            }
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
        var location: String = ""
        var favorite: Bool = false

        city = cities[indexPath.row].city
        if cities[indexPath.row].country == "FR" || cities[indexPath.row].country == "DE" {
            location = cities[indexPath.row].locations
        } else {
            location = cities[indexPath.row].location
        }

        favorite = cities[indexPath.row].favorite

        cell.configure(with: city, location: location, favorite: favorite)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}

extension CitiesViewController: SettingsViewControllerDelegate {

    func refresh() {
        if SettingsService.localization == "GeoLocalization" {
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
        } else {
            isoCountryCodeToSearch = SettingsService.countryISO
            countryLabel.text = Locale.current.localizedString(forRegionCode: SettingsService.countryISO)!
            country = self.countryLabel.text!
        }
        searchBar.text = ""
        self.cities.removeAll()
        self.tableView.reloadData()
    }

}
