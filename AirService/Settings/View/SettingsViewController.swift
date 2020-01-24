//
//  SettingsViewController.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
//
//protocol SettingsViewControllerDelegate: AnyObject {
//    func refreshData()
//}

class SettingsViewController: UIViewController {

    @IBAction func saveSettings(_ sender: Any) {
        let localizationIndex = choiceOfLocalization.selectedSegmentIndex

        settingsService.localization = (localizationIndex == 0) ? "GeoLocalization" : "country"
        if settingsService.localization == "country" {
            settingsService.countryISO = getSelectedCountry()
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var countryPickerView: UIPickerView!

    @IBOutlet weak var choiceOfLocalization: UISegmentedControl!

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        callAPI()
        if settingsService.localization == "GeoLocalization" {
            choiceOfLocalization.selectedSegmentIndex = 0
        } else {
            choiceOfLocalization.selectedSegmentIndex = 1
        }
    }

    private let apiFetcherCountries = ApiServiceCountries()
    let settingsService = Settings()
    var countries = ListCountriesService.shared.listCountries
//    weak var delegate: SettingsViewControllerDelegate?

    private func callAPI() {
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

    private func updateBeforeLoadView() {
        countries = ListCountriesService.shared.listCountries
        countryPickerView.reloadAllComponents()
        let row = getSelectedRow()
        countryPickerView.selectRow(row, inComponent: 0, animated: true)
    }

    private func getSelectedCountry() -> String {
        if countries.count > 0 {
            let index = countryPickerView.selectedRow(inComponent: 0)
                return countries[index].code
            }
            return ""
    }

    private func getSelectedRow() -> Int {
        for indice in 0...countries.count-1
            where countries[indice].code == settingsService.countryISO {
                return indice
        }
        return -1
    }

    ///
    /// function toggleActivityIndicator
    ///     - depending of calling show :o
    ///         - to unhidde/hidde activity indicator
    ///
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}

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
