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
    @IBOutlet weak var pollutantTwo: UITextField!
    @IBOutlet weak var pollutantThree: UITextField!
    @IBOutlet weak var pollutantFour: UITextField!
    @IBOutlet weak var pollutantFive: UITextField!
    @IBOutlet weak var pollutantSix: UITextField!

    @IBOutlet weak var viewQuality: UIView!

    @IBAction func showPollutants(_ sender: Any) {
        showPopUp()
    }

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var pieChartPolOne: PieChartView!
    @IBOutlet weak var pieChartPolTwo: PieChartView!
    @IBOutlet weak var pieChartPolThree: PieChartView!
    @IBOutlet weak var pieChartPolFour: PieChartView!
    @IBOutlet weak var pieChartPolFive: PieChartView!
    @IBOutlet weak var pieChartPolSix: PieChartView!

    var cityDetail = [ListLatestMeasure]()
    var locationsName: String = ""
    var indiceData = PieChartDataEntry(value: 0)
    var indiceDataFull = PieChartDataEntry(value: 0)

    var indiceDataEntries = [PieChartDataEntry]()

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        fillCityDetail()
        initMainChart()
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

    private func initMainChart() {
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
        chartDataSet.valueTextColor = (NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor))

        let colors = [NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor),
                      NSUIColor(cgColor: UIColor(named: "colorIndiceDataFull")!.cgColor)]
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
            color = UIColor(named: "colorLevelOne") ?? .white
        case 2:
            color = UIColor(named: "colorLevelTwo") ?? .white
        case 3:
            color = UIColor(named: "colorLevelThree") ?? .white
        case 4:
            color = UIColor(named: "colorLevelFour") ?? .white
        case 5:
            color = UIColor(named: "colorLevelFive") ?? .white
        case 6:
            color = UIColor(named: "colorLevelSix") ?? .white
        case 7:
            color = UIColor(named: "colorLevelSeven") ?? .white
        case 8:
            color = UIColor(named: "colorLevelEight") ?? .white
        case 9:
            color = UIColor(named: "colorLevelNine") ?? .white
        default:
            color = UIColor(named: "colorLevelDefault") ?? .white
        }
        qualityName.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
    }
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            var pollutantValue: Double = 0
            pollutantValue = cityDetail[0].measurements[indice].value
            if cityDetail[0].measurements[indice].unit == "ppm" {
                pollutantValue *= 1000
            }
            let valueMax = searchValueMaxPollutant(parameter: cityDetail[0].measurements[indice].parameter)
            initChartDetail(numPol: indice,
                            pollutantValue: pollutantValue,
                            valueMax: valueMax,
                            parameter: cityDetail[0].measurements[indice].parameter)
        }
    }

    private func searchValueMaxPollutant(parameter: String) -> Double {
        var value: Double = 0
        switch parameter {
        case "co":
            value = CarbonMonoxide.list[7].value * 1.5
        case "no2":
            value = NitrogenDioxide.list[7].value * 1.5
        case "o3":
            value = Ozone.list[7].value * 1.5
        case "pm10":
            value = ParticulateTen.list[7].value * 1.5
        case "pm25":
            value = ParticulateTwoFive.list[7].value * 1.5
        case "so2":
            value = SulfurDioxide.list[7].value * 1.5
        default:
            value = 0
        }
        return value
    }

    private func initChartDetail(numPol: Int, pollutantValue: Double, valueMax: Double, parameter: String) {
        var typePol: PieChartView = pieChartPolOne
        switch numPol {
        case 0:
            typePol = pieChartPolOne
            pollutantOne.text = parameter
        case 1:
            typePol = pieChartPolTwo
            pollutantTwo.text = parameter
        case 2:
            typePol = pieChartPolThree
            pollutantThree.text = parameter
        case 3:
            typePol = pieChartPolFour
            pollutantFour.text = parameter
        case 4:
            typePol = pieChartPolFive
            pollutantFive.text = parameter
        case 5:
            typePol = pieChartPolSix
            pollutantSix.text = parameter
        default:
            print("")
        }
        typePol.holeColor = nil
        typePol.legend.enabled = false
        typePol.chartDescription?.text = ""
        typePol.holeRadiusPercent = 0.90
        typePol.rotationAngle = 90
        let raleway = NSUIFont (name: "Raleway", size: 14)
        typePol.centerAttributedText = NSAttributedString(string:
            String(format: "%.0f", pollutantValue),
                attributes: [NSAttributedString.Key.font: raleway!])
        indiceData.value = pollutantValue
        indiceDataFull.value = valueMax - pollutantValue
        indiceDataEntries = [indiceData, indiceDataFull]

        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor))

        let colors = [NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor),
                      NSUIColor(cgColor: UIColor(named: "colorIndiceDataFull")!.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.label = ""
        typePol.data = chartData
    }
}
