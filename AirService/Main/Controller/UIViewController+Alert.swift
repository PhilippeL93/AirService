//
//  UIViewController+Alert.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - extension
    ///   alert in order to display message
    func alert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    ///    getErrors in order to display message
    func getErrors(type: Errors ) {
        switch type {
        case .noInternetConnection:
            alert(message: Errors.noInternetConnection.rawValue, title: "Error")
        case .noCountries:
            alert(message: Errors.noCountries.rawValue, title: "Error")
        case .noCities:
                alert(message: Errors.noCities.rawValue, title: "Error")
        case .noData:
            alert(message: Errors.noData.rawValue, title: "Error")
        case .noURL:
            alert(message: Errors.noURL.rawValue, title: "Error")
        case .dataNotCompliant:
            alert(message: Errors.dataNotCompliant.rawValue, title: "Error")
        case .noMeasurements:
            alert(message: Errors.noMeasurements.rawValue, title: "Error")
        case .noLocationServices:
            alert(message: Errors.noLocationServices.rawValue, title: "Location Services")
        }
    }

    ///    getErrorsText in order to know text for error
    func getErrorsText(type: Errors ) -> String {
        switch type {
        case .noInternetConnection:
            return Errors.noInternetConnection.rawValue
        case .noCountries:
            return Errors.noCountries.rawValue
        case .noCities:
            return Errors.noCities.rawValue
        case .noData:
            return Errors.noData.rawValue
        case .noURL:
            return Errors.noURL.rawValue
        case .dataNotCompliant:
            return Errors.dataNotCompliant.rawValue
        case .noMeasurements:
            return Errors.noMeasurements.rawValue
        case .noLocationServices:
            return Errors.noLocationServices.rawValue
        }
    }
}
