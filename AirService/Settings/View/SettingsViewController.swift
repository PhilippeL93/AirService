//
//  SettingsViewController.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - class SettingsViewController
class SettingsViewController: UIViewController {

    // MARK: - buttons
    ///   saveSettings in order to save in userDefaults
    @IBAction func saveSettings(_ sender: Any) {
        saveUserDefaults()
    }

    // MARK: - outlets
    ///   link between view elements and controller
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var choiceOfLocalization: UISegmentedControl!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        callAPICountries()
        if settingsService.localization == "GeoLocalization" {
            choiceOfLocalization.selectedSegmentIndex = 0
        } else {
            choiceOfLocalization.selectedSegmentIndex = 1
        }
    }

    // MARK: - variables
    private let apiFetcherCountries = ApiServiceCountries()
    let settingsService = Settings()
    var countries = ListCountriesService.shared.listCountries

    // MARK: - functions
    ///   callAPICountries in order to retrieve all countries
    ///    - apiFetcherCountries in order to retrieve countries
    ///    - if success
    ///      - updateBeforeLoadView
    ///    - else
    ///      - display error message
    private func callAPICountries() {
        toggleActivityIndicator(shown: true)

        self.apiFetcherCountries.getApiCountries { (success, errors ) in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
                if success {
                    self.updateBeforeLoadView()
                } else {
                    guard let errors = errors else {
                        return
                    }
                    self.getErrors(type: errors)
                }
            }
        }
    }

    ///   updateBeforeLoadView in order to prepare display data
    private func updateBeforeLoadView() {
        countries = ListCountriesService.shared.listCountries
        countryPickerView.reloadAllComponents()
        let row = getSelectedRow()
        countryPickerView.selectRow(row, inComponent: 0, animated: true)
    }

    ///   getSelectedCountry in order to return country selected by user
    private func getSelectedCountry() -> String {
        if countries.count > 0 {
            let index = countryPickerView.selectedRow(inComponent: 0)
                return countries[index].code
            }
            return ""
    }

    ///   getSelectedRow in order to select country saved in userDefaults
    private func getSelectedRow() -> Int {
        for indice in 0...countries.count-1
            where countries[indice].code == settingsService.countryISO {
                return indice
        }
        return -1
    }

    ///   saveUserDefaults in order to save userDefaults
    ///    - if geolocalization and location service is disabled
    ///      - message to activate location services
    ///      - exit
    ///    - save userDefaults
    private func saveUserDefaults() {
        let localizationIndex = choiceOfLocalization.selectedSegmentIndex
        let choiceOfLocalization = (localizationIndex == 0) ? "GeoLocalization" : "country"

        if choiceOfLocalization == "GeoLocalization" {
            if CLLocationManager.locationServicesEnabled() == true {
                if CLLocationManager.authorizationStatus() == .restricted ||
                    CLLocationManager.authorizationStatus() == .denied {
                    getErrors(type: .noLocationServices)
                    return
                }
            }
        }
        settingsService.countryISO = getSelectedCountry()
        settingsService.localization = (localizationIndex == 0) ? "GeoLocalization" : "country"
    }

    /// toggleActivityIndicator
    ///     - depending of calling show to unhidde/hidde activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}

// MARK: - extension for UIPickerView
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {

        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = UIColor.white
        label.font = UIFont (name: "Raleway", size: 22)
        label.text =  countries[row].name + " (" + countries[row].code + ")"
        label.textAlignment = .center
        return label
    }
}
