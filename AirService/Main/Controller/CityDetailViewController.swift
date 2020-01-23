//
//  CityDetailViewController.swift
//  AirService
//
//  Created by Philippe on 10/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit
import Charts

class CityDetailViewController: UIViewController {

    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var qualityName: UITextField!
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

    @IBAction func showPollutants(_ sender: Any) {
        showPopUp()
    }
    @IBOutlet weak var pieChart: PieChartView!

    var cityDetail = [ListLatestMeasure]()
    var locationsName: String = ""
    var indiceData = PieChartDataEntry(value: 0)
    var indiceDataFull = PieChartDataEntry(value: 0)

    var indiceDataEntries = [PieChartDataEntry]()

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        fillCityDetail()
        initChart()
        super.viewDidLoad()
        }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        fillCityDetail()
        super.viewDidLoad()
        }

    // MARK: - functions
    ///   function fillRecipe in order to display recipe
    ///

    private func showPopUp() {
        let popOverVC = UIStoryboard(
            name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pollutantsPopUp")
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }

    private func initChart() {

        pieChart.holeColor = nil
        pieChart.legend.enabled = false
        pieChart.chartDescription?.text = ""
        pieChart.holeRadiusPercent = 0.90
        pieChart.rotationAngle = 90
        let raleway = NSUIFont (name: "Raleway", size: 22)
        pieChart.centerAttributedText = NSAttributedString(string:
            String(format: "%.0f", cityDetail[0].qualityIndicator),
                attributes: [NSAttributedString.Key.font: raleway!])
        indiceData.value = cityDetail[0].qualityIndicator
        indiceDataFull.value = 200 - cityDetail[0].qualityIndicator
        indiceDataEntries = [indiceData, indiceDataFull]
        updateChartData()
    }

    private func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: UIColor(named: "indiceData")!.cgColor))

        let colors = [NSUIColor(cgColor: UIColor(named: "indiceData")!.cgColor),
                      NSUIColor(cgColor: UIColor(named: "indiceDataFull")!.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.label = ""

        pieChart.data = chartData
    }

    private func fillCityDetail() {

        cityName.text = cityDetail[0].city

        if cityDetail[0].country == "DE" {
            department.text = cityDetail[0].locations
            if cityDetail[0].locations.isEmpty {
                department.text = locationsName
            }
        } else {
            department.text = cityDetail[0].location
        }
        if cityDetail[0].country == "FR" {
            department.text = cityDetail[0].city
            cityName.text = cityDetail[0].locations
            if cityDetail[0].locations.isEmpty {
                cityName.text = locationsName
            }
        }

        qualityName.text = cityDetail[0].qualityName
//        qualityIndicator.text = String(format: "%.0f", cityDetail[0].qualityIndicator)
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
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 3:
            color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 4:
            color = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case 5:
            color = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case 6:
            color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 7:
            color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        case 8:
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 9:
            color = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        default:
            print("erreur")
        }
        qualityName.backgroundColor = color
//        qualityIndicator.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
    }
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            let pollutantValue = String(format: "%.0f", cityDetail[0].measurements[indice].value)
                + " " + cityDetail[0].measurements[indice].unit
            let pollutantName = " \(String(cityDetail[0].measurements[indice].parameter)) : "
            switch indice {
            case 0:
                pollutantOne.text = pollutantName
                pollutantOneValue.text = pollutantValue
            case 1:
                pollutantTwo.text = pollutantName
                pollutantTwoValue.text = pollutantValue
            case 2:
                pollutantThree.text = pollutantName
                pollutantThreeValue.text = pollutantValue
            case 3:
                pollutantFour.text = pollutantName
                pollutantFourValue.text = pollutantValue
            case 4:
                pollutantFive.text = pollutantName
                pollutantFiveValue.text = pollutantValue
            case 5:
                pollutantSix.text = pollutantName
                pollutantSixValue.text = pollutantValue
            default:
                print("")
            }
        }
    }
}
