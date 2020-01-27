//
//  SettingsViewController.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

// MARK: - class SettingsViewController
class SettingsViewController: UIViewController {

    // MARK: - buttons
    ///   function saveSettings in order to save in userDefaults
    ///
    @IBAction func saveSettings(_ sender: Any) {
        let localizationIndex = choiceOfLocalization.selectedSegmentIndex
        settingsService.localization = (localizationIndex == 0) ? "GeoLocalization" : "country"
        if settingsService.localization == "country" {
            settingsService.countryISO = getSelectedCountry()
        }
    }

    // MARK: - outlets
    ///   link between view elements and controller
    ///
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var choiceOfLocalization: UISegmentedControl!

    override func viewDidLoad() {
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
    ///
    private let apiFetcherCountries = ApiServiceCountries()
    let settingsService = Settings()
    var countries = ListCountriesService.shared.listCountries

    // MARK: - functions
    ///   function callAPICountries in order to retrieve all countries
    ///    - call func apiFetcherCountries in order to retrieve countries
    ///    - if success
    ///      - func updateBeforeLoadView
    ///    - else
    ///      - display error message
    ///
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

    ///   function updateBeforeLoadView in order to prepare display data
    ///
    private func updateBeforeLoadView() {
        countries = ListCountriesService.shared.listCountries
        countryPickerView.reloadAllComponents()
        let row = getSelectedRow()
        countryPickerView.selectRow(row, inComponent: 0, animated: true)
    }

    ///   function getSelectedCountry in order to return country selected by user
    ///
    private func getSelectedCountry() -> String {
        if countries.count > 0 {
            let index = countryPickerView.selectedRow(inComponent: 0)
                return countries[index].code
            }
            return ""
    }

    ///   function getSelectedRow in order to select country saved in userDefaults
    ///
    private func getSelectedRow() -> Int {
        for indice in 0...countries.count-1
            where countries[indice].code == settingsService.countryISO {
                return indice
        }
        return -1
    }

    /// function toggleActivityIndicator
    ///     - depending of calling show :o
    ///         - to unhidde/hidde activity indicator
    ///
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
