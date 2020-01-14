//
//  CityDetailViewController.swift
//  AirService
//
//  Created by Philippe on 10/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var cityName: UITextField!

    @IBOutlet weak var department: UITextField!

    @IBOutlet weak var qualityName: UITextField!

    @IBOutlet weak var qualityImage: UIImageView!

    @IBOutlet weak var qualityIndicator: UITextField!

    @IBOutlet weak var hourLastUpdated: UITextField!

    @IBOutlet weak var sourceName: UITextField!

    @IBOutlet weak var pollutantCO: UITextField!

    @IBOutlet weak var pollutantNO: UITextField!

    @IBOutlet weak var pollutantO3: UITextField!

    @IBOutlet weak var pollutantPM25: UITextField!

    @IBOutlet weak var pollutantPM10: UITextField!

    @IBOutlet weak var pollutantSO2: UITextField!

    @IBOutlet weak var viewQuality: UIView!

    var cityDetail = [ListLatestMeasure]()
//    var selectedCity = Int()

    override func viewDidLoad() {
        fillCityDetail()
        super.viewDidLoad()
//        imageLabel.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = imageLabel.bounds
//        existingFavoriteRecipe()
        }

    override func viewDidAppear(_ animated: Bool) {
        fillCityDetail()
        super.viewDidLoad()
//        imageLabel.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = imageLabel.bounds
//        existingFavoriteRecipe()
        }

    // MARK: - functions
    ///   function fillRecipe in order to display recipe
    ///
    func fillCityDetail() {

        cityName.text = cityDetail[0].city

        if cityDetail[0].country == "FR" || cityDetail[0].country == "DE" {
            department.text = cityDetail[0].locations
        } else {
            department.text = cityDetail[0].location
        }

        qualityName.text = cityDetail[0].qualityName
        qualityIndicator.text = String(format: "%.0f", cityDetail[0].qualityIndicator)
        hourLastUpdated.text = cityDetail[0].hourLastUpdated
        sourceName.text = cityDetail[0].sourceName
        setQualityImage()
        setColor()
        setPollutant()
    }

    private func setQualityImage() {
        switch cityDetail[0].qualityIndice {
        case 1, 2:
            qualityImage.image = #imageLiteral(resourceName: "icone_VeryGood.png")
        case 3, 4:
            qualityImage.image = #imageLiteral(resourceName: "icone_Good.png")
        case 5:
            qualityImage.image = #imageLiteral(resourceName: "icone_Medium.png")
        case 6:
            qualityImage.image = #imageLiteral(resourceName: "icone_Poor.png")
        case 7, 8:
            qualityImage.image = #imageLiteral(resourceName: "icone_Bad.png")
        case 9:
            qualityImage.image = #imageLiteral(resourceName: "icone_VeryBad.png")
        default:
            print("erreur")
        }
    }

    private func setColor() {
        var color: UIColor
        switch cityDetail[0].qualityColor {
        case "green" :
            color = UIColor.green
        case "yellow" :
            color = UIColor.yellow
        case "orange" :
            color = UIColor.orange
        case "red" :
            color = UIColor.red
        case "purple" :
            color = UIColor.purple
        default:
            color = UIColor.white
        }

        qualityName.backgroundColor = color
        qualityImage.layer.backgroundColor = color.cgColor
        qualityIndicator.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
    }
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            switch cityDetail[0].measurements[indice].parameter {
            case "co":
                pollutantCO.text = String(cityDetail[0].measurements[indice].value)
            case "no2":
                pollutantNO.text = String(cityDetail[0].measurements[indice].value)
            case "o3":
                pollutantO3.text = String(cityDetail[0].measurements[indice].value)
            case "pm10":
                pollutantPM10.text = String(cityDetail[0].measurements[indice].value)
            case "pm25":
                pollutantPM25.text = String(cityDetail[0].measurements[indice].value)
            case "so2":
                pollutantSO2.text = String(cityDetail[0].measurements[indice].value)
            default:
                print("")
            }
        }
    }
}
