//
//  SettingsViewController.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func refresh()
}

class SettingsViewController: UIViewController {

    @IBAction func saveSettings(_ sender: Any) {
        SettingsService.countryISO = getSelectedCountry()
        let localizationIndex = choiceOfLocalization.selectedSegmentIndex
        SettingsService.localization = (localizationIndex == 0) ? "GeoLocalization" : "country"
        self.delegate?.refresh()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var countryPickerView: UIPickerView!

    @IBOutlet weak var choiceOfLocalization: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
        //        countries = ListCountriesService.shared.listCountries
        //        let country = SettingsService.country
        //        currencyLabel.text = currency
    }

        private let apiFetcher = ApiServiceCountries()

        var countries = ListCountriesService.shared.listCountries
        weak var delegate: SettingsViewControllerDelegate?

    private func callAPI() {
        self.apiFetcher.getApiCountries { (success, errors ) in
            DispatchQueue.main.async {
                if success {
                    self.countries = ListCountriesService.shared.listCountries
                    self.countryPickerView.reloadAllComponents()
                } else {
                    guard let errors = errors else {
                        return
                    }
                    self.getErrors(type: errors)
                }
            }
        }
    }

    private func getSelectedCountry() -> String {
        if countries.count > 0 {
            let index = countryPickerView.selectedRow(inComponent: 0)
                return countries[index].code
            }
            return ""
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name + " (" + countries[row].code + ")"
    }
}
