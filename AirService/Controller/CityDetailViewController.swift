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

    @IBOutlet weak var pollutantOne: UITextField!
    @IBOutlet weak var pollutantOneValue: UITextField!
    @IBOutlet weak var pollutantTwo: UITextField!
    @IBOutlet weak var pollutantTwoValue: UITextField!
    @IBOutlet weak var pollutantThree: UITextField!
    @IBOutlet weak var pollutantThreeValue: UITextField!
    @IBOutlet weak var pollutantFour: UITextField!
    @IBOutlet weak var pollutantFourValue: UITextField!
    @IBOutlet weak var pollutantFive: UITextField!
    @IBOutlet weak var pollutantFiveValue: UITextField!
    @IBOutlet weak var pollutantSix: UITextField!
    @IBOutlet weak var pollutantSixValue: UITextField!

    @IBOutlet weak var viewQuality: UIView!

    var cityDetail = [ListLatestMeasure]()
//    var selectedCity = Int()

    override func viewDidLoad() {
        fillCityDetail()
        super.viewDidLoad()
        }

    override func viewDidAppear(_ animated: Bool) {
        fillCityDetail()
        super.viewDidLoad()
        }

    // MARK: - functions
    ///   function fillRecipe in order to display recipe
    ///
    func fillCityDetail() {

        cityName.text = cityDetail[0].city

//        if cityDetail[0].country == "FR" || cityDetail[0].country == "DE" {
        if cityDetail[0].country == "DE" {
            department.text = cityDetail[0].locations
        } else {
            department.text = cityDetail[0].location
        }
        if cityDetail[0].country == "FR" {
            department.text = cityDetail[0].city
            cityName.text = cityDetail[0].locations
        }

        qualityName.text = cityDetail[0].qualityName
        qualityIndicator.text = String(format: "%.0f", cityDetail[0].qualityIndicator)
        hourLastUpdated.text = " \(String(cityDetail[0].hourLastUpdated[0 ..< 10]))" +
                                " à : \(String(cityDetail[0].hourLastUpdated[11 ..< 19]))"
        sourceName.text = cityDetail[0].sourceName
        setQualityAndColorImage()
        setPollutant()
    }

    private func setQualityAndColorImage() {
        var color: UIColor = UIColor.white
        switch cityDetail[0].qualityIndice {
        case 1:
//            qualityImage.image = #imageLiteral(resourceName: "icone_VeryGood.png")
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case 2:
//            qualityImage.image = #imageLiteral(resourceName: "icone_VeryGood.png")
            color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 3:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Good.png")
            color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 4:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Good.png")
            color = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case 5:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Medium.png")
            color = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case 6:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Poor.png")
            color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 7:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Bad.png")
            color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        case 8:
//            qualityImage.image = #imageLiteral(resourceName: "icone_Bad.png")
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 9:
//            qualityImage.image = #imageLiteral(resourceName: "icone_VeryBad.png")
            color = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        default:
            print("erreur")
        }
        qualityName.backgroundColor = color
        qualityImage.layer.backgroundColor = color.cgColor
        qualityIndicator.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
    }
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            switch indice {
            case 0:
                pollutantOne.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantOneValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            case 1:
                pollutantTwo.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantTwoValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            case 2:
                pollutantThree.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantThreeValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            case 3:
                pollutantFour.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantFourValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            case 4:
                pollutantFive.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantFiveValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            case 5:
                pollutantSix.text = " \(String(cityDetail[0].measurements[indice].parameter)) : "
                pollutantSixValue.text =
                " \(String(cityDetail[0].measurements[indice].value)) \(cityDetail[0].measurements[indice].unit)"
            default:
                print("")
            }
        }
    }
}
