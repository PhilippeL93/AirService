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
    }

    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }

    var locationManager = CLLocationManager()
    var cities = ListCitiesService.shared.listCities

    private let apiFetcher = ApiServiceCities()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let userLocation = locations[0]
        let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude)
        location.fetchCityAndCountry { isoCountryCode, error in
            guard let isoCountryCode = isoCountryCode,
                error == nil else { return }
//            guard let city = city, let country = country, let isoCountryCode = isoCountryCode,
//                error == nil else { return }
//            print(city + ", " + country + ", " + isoCountryCode)
            self.apiFetcher.getApiCities(countryToSearch: isoCountryCode) { (success, errors ) in
                DispatchQueue.main.async {
                    //                self.toggleActivityIndicator(shown: false)
                    if success {
                    } else {
                        guard let errors = errors else {
                            return
                        }
                        self.getErrors(type: errors)
                    }
                }
                self.cities = ListCitiesService.shared.listCities
                self.tableView.reloadData()
            }
        }

    }
}

// MARK: - extension Data
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

        let quality = 150

        cell.configure(with: city, quality: quality)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}
