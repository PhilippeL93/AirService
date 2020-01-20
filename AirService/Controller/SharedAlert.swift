//
//  SharedAlert.swift
//  AirService
//
//  Created by Philippe on 24/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - extension
    ///   common function alert in order to display message
    ///
    func alert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    ///    commopn function getErrors in order to display message
    ///
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
//        case .forbidCharacter:
//            alert(message: Errors.forbidCharacter.rawValue, title: "Error")
//        case .favoriteListEmpty:
//            alert(message: Errors.favoriteListEmpty.rawValue, title: "Error")
        }
    }

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
    //        case .forbidCharacter:
    //            alert(message: Errors.forbidCharacter.rawValue, title: "Error")
    //        case .favoriteListEmpty:
    //            alert(message: Errors.favoriteListEmpty.rawValue, title: "Error")
            }
        }
}
