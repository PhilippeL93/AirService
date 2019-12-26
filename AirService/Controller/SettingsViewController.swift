//
//  SettingsViewController.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        callAPI()
        countries = ListCountriesService.shared.listCountries
//        let country = SettingsService.country
//        currencyLabel.text = currency
    }

    private let apiFetcher = ApiServiceCountries()

    var countries = ListCountriesService.shared.listCountries

    @IBAction func dismiss() {
//        guard let country = getSelectedCountry() else { return }
//        SettingsService.country = country
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var countryPickerView: UIPickerView!

//    private func callAPI() {
////        toggleActivityIndicator(shown: true)
//
////        let ingredientToSearch = prepareIngredientsToSearch()
//
//        apiFetcher.getApiCountries() { (success, errors ) in
//            DispatchQueue.main.async {
////                self.toggleActivityIndicator(shown: false)
//                if success {
//                } else {
//                    guard let errors = errors else {
//                        return
//                    }
//                    self.getErrors(type: errors)
//                }
//            }
//        }
//    }

}

//func getSelectedCountry() {
//    if countries.count > 0 {
//        let index = countryPickerView.selectedRow(inComponent: 0)
//            return persons[index]
//        }
//        return nil
//}

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
