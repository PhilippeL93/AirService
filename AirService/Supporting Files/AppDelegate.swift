//
//  AppDelegate.swift
//  AirService
//
//  Created by Philippe on 16/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()

    private let apiFetcher = ApiServiceCountries()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        apiFetcher.getApiCountries { (success, errors ) in
            DispatchQueue.main.async {
                //                self.toggleActivityIndicator(shown: false)
                if success {
                } else {
                    guard let errors = errors else {
                        return
                    }
//                    self.getErrors(type: errors)
                }
            }
        }
    }
}
