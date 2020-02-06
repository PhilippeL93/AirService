//
//  CitiesViewController.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: extension
/// in order to retrieve ISO country code of location based on latitude and longitude of iPhone localization
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping
         (_ country: String?, _ isoCountryCode: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.country, $0?.first?.isoCountryCode, $1)
        }
    }
}

// MARK: class CitiesViewController
class CitiesViewController: UIViewController {

    // MARK: - outlets
    ///   link between view elements and controller
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var message: UILabel!

    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        checkRefreshView()
        message.isHidden = true
    }

    // MARK: - variables
    var locationManager = CLLocationManager()
    var citiesFavorite: [CitiesFavorite]?
    let settings = Settings()
    var cities = ListCitiesService.shared.listCities
    var searchActive: Bool = false
    var filtered: [String] = []
    var isoCountryCodeToSearch = ""
    var country = ""
    var errorsLocation: Errors?
    var oldIsoCountryCode: String = ""
    let checkCountry = CheckCountry()

    private let apiFetchCities = ApiServiceCities()
    private let apiFetchMeasures = ApiServiceLatestMeasures()

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
        cities.removeAll()
        tableView.reloadData()
        searchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    // MARK: - functions
    ///   searchBar in order to manage characters filled in searchBar
    ///    - if number of characters > 2
    ///      - searchAPIWithLocation
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        message.isHidden = true
        if searchText.count <= 2 {
            searchActive = false
            self.cities.removeAll()
            self.tableView.reloadData()
        } else {
            searchAPIWithLocation(searchText: searchText)
        }
    }

    ///   searchAPIWithLocation
    ///   - apiFetchCities with call options = location
    ///     - if success
    ///       - searchAPIWithCity
    ///     - else
    ///       - save error message
    ///       - searchAPIWithCity
    private func searchAPIWithLocation(searchText: String) {
        if settings.localization == "GeoLocalization" {
            if CLLocationManager.locationServicesEnabled() == true {
                if CLLocationManager.authorizationStatus() == .restricted ||
                    CLLocationManager.authorizationStatus() == .denied {
                    getErrors(type: .noLocationServices)
                    return
                }
            }
        }
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
    ///   searchAPIWithCity in order to manage characters filled in searchBar
    ///    - apiFetchCities with call options = city
    ///      - if success
    ///        - if number of cities found > 1
    ///          - reload tableview
    ///        - else
    ///          - message with no cities found
    ///      - else
    ///        - if error message with call location is empty
    ///          - if number of cities found > 1
    ///            - reload tableview
    ///          - else
    ///            - message with no cities found
    ///        - else
    ///          - call message with error message
    func searchAPIWithCity(searchText: String) {
        self.apiFetchCities.getApiCities(
            countryToSearch: self.isoCountryCodeToSearch,
            cityToSearch: searchText,
            typeOfSearch: "city") { (success, errors ) in
                DispatchQueue.main.async {
                    if success {
                        self.cities = ListCitiesService.shared.listCities
                        if self.cities.count >= 1 {
                            self.tableView.reloadData()
                        } else {
                            self.displayMessage(error: .noCities)
                        }
                    } else {
                        if self.errorsLocation == nil {
                            self.cities = ListCitiesService.shared.listCities
                            if self.cities.count >= 1 {
                                self.tableView.reloadData()
                            } else {
                                self.displayMessage(error: .noCities)
                            }
                        } else {
                            guard let errors = errors else {
                                return }
                            if self.errorsLocation != nil {
                                self.displayMessage(error: errors)
                            }
                        }
                    }
                }
        }
    }

    ///   displayMessage in order to display error message
    private func displayMessage(error: Errors) {
        self.message.text = " \(self.getErrorsText(type: error))"
        self.message.isHidden = false
        self.cities.removeAll()
        self.tableView.reloadData()
    }

    ///   displayCityDetaii in order to search latest measures of city selected and display detail of measures found
    ///    - apiFetchMeasures for city selected
    ///    - if sucess
    ///       - CityDetail in order to display detail of measures
    ///     - else
    ///       - display error message
    private func displayCityDetail(countryToSearch: String,
                                   locationToSearch: String, locationsName: String, cityToSearch: String) {
        self.apiFetchMeasures.getApiLatestMeasures(
            countryToSearch: countryToSearch,
            locationToSearch: locationToSearch,
            cityToSearch: cityToSearch
        ) { (success, errors) in
            DispatchQueue.main.async {
                if success {
                    guard let destVC = self.storyboard?.instantiateViewController(withIdentifier: "cityDetail")
                        as? CityDetailViewController else {
                            return
                    }
                    destVC.locationsName = locationsName
                    destVC.cityDetail = [ListLatestMeasuresService.shared.listLatestMeasures[0]]
                    self.show(destVC, sender: self)
                } else {
                    guard let errors = errors else {
                        return }
                    self.getErrors(type: errors)
                }
            }
        }
    }

    ///   checkRefreshView in order to determine refreshing view depending on setting
    ///   - check userDefaults already existing
    ///   - if true (existing)
    ///     - checkSettingForRefreshView
    ///   - else
    ///     - localizeiPhone (first launching of app)
    private func checkRefreshView() {
        let userDefaults = checkUserDefaults()
        switch userDefaults {
        case true:
            checkSettingForRefreshView()
        case false:
            localizeiPhone()
        }
    }

    ///   checkUserDefaults in order to detect existing of userDefaults
    private func checkUserDefaults() -> Bool {
        let userDefaultsGeolocalization = checkUserDefaultsGeoLocalization()
        let userDefaultsCountryIso = checkUserDefaultsIsoCountryCodeSetting()
        if userDefaultsGeolocalization == true || userDefaultsCountryIso == true {
            return true
        } else {
            return false
        }
    }

    ///   checkUserDefaultsGeoLocalization in order to detect userDefaults for geo localization
    private func checkUserDefaultsGeoLocalization() -> Bool {
        guard settings.localization != nil else {
            return false
        }
        return true
    }

    ///   checkUserDefaultsIsoCountryCodeSetting in order to detect userDefaults for country
    private func checkUserDefaultsIsoCountryCodeSetting() -> Bool {
        guard settings.countryISO != nil else {
            return false
        }
        return true
    }

    ///   checkSettingForRefreshView in order to refresh view depending on setting
    ///   - if geo localisation
    ///     - localizeiPhone
    ///   - else
    ///     - changing of country stored i userdefault
    ///   - checkUpdateIsoCountryCode
    private func checkSettingForRefreshView() {
        oldIsoCountryCode = isoCountryCodeToSearch
        if settings.localization == "GeoLocalization" {
            localizeiPhone()
        } else {
            isoCountryCodeToSearch = settings.countryISO ?? "FR"
            countryLabel.text = Locale.current.localizedString(forRegionCode: isoCountryCodeToSearch)
            country = self.countryLabel.text!
        }
        checkUpdateIsoCountryCode(oldIsoCountryCode: oldIsoCountryCode)
    }

    ///   localizeiPhone
    private func localizeiPhone() {
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied {
                getErrors(type: .noLocationServices)
                return
            }
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
        self.searchBar.delegate = self
        self.tableView.rowHeight = 80
    }

    ///   checkUpdateIsoCountryCode in order to detect change of settings
    private func checkUpdateIsoCountryCode(oldIsoCountryCode: String) {
        if oldIsoCountryCode != isoCountryCodeToSearch {
            searchBar.text = ""
            cities.removeAll()
            tableView.reloadData()
        } else {
            guard let countOfCities = cities.count as Int? else {
                return
            }
            if countOfCities > 0 {
            for indice in 0...countOfCities-1 {
                let favoriteFound = getFavorite(indice: indice)
                cities[indice].favorite = favoriteFound
            }
                tableView.reloadData()
            }
        }
    }

    ///   getFavorite in order to detect change of favorites
    private func getFavorite(indice: Int) -> Bool {
        citiesFavorite = settings.favoriteCitiesList as [CitiesFavorite]?
        guard let countOfFavorites = citiesFavorite?.count else {
            return false
        }
        if countOfFavorites >= 1 {
            for indiceFavorite in 0...countOfFavorites-1
                where citiesFavorite?[indiceFavorite].ident == cities[indice].ident {
                    return true
            }
        }
        return false
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

        let country = cities[indexPath.row].country
        let typeCountry = checkCountry.checkCountry(country: country)
        switch typeCountry {
        case "countryTypeOne":
            location = cities[indexPath.row].locations
        case "countryTypeTwo":
            location = cities[indexPath.row].locations
        default:
            location = cities[indexPath.row].location
        }

        favorite = cities[indexPath.row].favorite

        cell.configure(with: country, city: city, location: location, favorite: favorite)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}

// MARK: - extension Delegate
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.frame.height / 6
        return size
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ListLatestMeasuresService.shared.removeAll()
        displayCityDetail(countryToSearch: isoCountryCodeToSearch,
                          locationToSearch: cities[indexPath.row].location,
                          locationsName: cities[indexPath.row].locations,
                          cityToSearch: cities[indexPath.row].city)
    }
}

extension CitiesViewController: CLLocationManagerDelegate {
    // MARK: - functions
    ///   function locationManager in order to manage localization of iPhone
    ///
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
            self.checkUpdateIsoCountryCode(oldIsoCountryCode: self.oldIsoCountryCode)
        }
    }
}
