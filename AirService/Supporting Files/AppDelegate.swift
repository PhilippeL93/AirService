//
//  AppDelegate.swift
//  AirService
//
//  Created by Philippe on 16/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var locationManager: CLLocationManager = CLLocationManager()

    private let apiFetcher = ApiServiceCountries()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
