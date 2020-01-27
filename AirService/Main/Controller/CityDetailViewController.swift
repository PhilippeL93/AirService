//
//  CityDetailViewController.swift
//  AirService
//
//  Created by Philippe on 10/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit
import Charts

// MARK: - class CityDetailViewController
class CityDetailViewController: UIViewController {

    // MARK: - outlets
    ///   link between view elements and controller
    ///
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

    // MARK: - variables
    ///
    var cityDetail = [ListLatestMeasure]()
    var locationsName: String = ""
    var indiceData = PieChartDataEntry(value: 0)
    var indiceDataFull = PieChartDataEntry(value: 0)
    var colorIndiceData: UIColor = UIColor(named: "colorIndiceData") ?? .white
    var colorIndiceDataFull: UIColor = UIColor(named: "colorIndiceDataFull") ?? .white

    var indiceDataEntries = [PieChartDataEntry]()

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        fillCityDetail()
        initMainChart()
        initCharts()
        super.viewDidLoad()
        }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        fillCityDetail()
        super.viewDidLoad()
        }

    // MARK: - functions
    ///   function showPopUp in order to call popUp contening detail of pollutants
    ///
    private func showPopUp() {
        let popOverVC = UIStoryboard(
            name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pollutantsPopUp")
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }

    ///   function initMainChart in order to initialize main pie chart
    ///
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

    ///   function updateChartData in order to prepare data for main pie chart
    ///
    private func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: colorIndiceData.cgColor),
                      NSUIColor(cgColor: colorIndiceDataFull.cgColor)]

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: colorIndiceData.cgColor))
        chartDataSet.colors = colors
        chartDataSet.label = ""
        pieChart.data = chartData
    }

    ///   function initCharts in order to initialize pollutants pie chart
    ///
    private func initCharts() {
        pollutantOne.backgroundColor = .white
        pollutantTwo.backgroundColor = .white
        pollutantThree.backgroundColor = .white
        pollutantFour.backgroundColor = .white
        pollutantFive.backgroundColor = .white
        pollutantSix.backgroundColor = .white

        for indice in 1...6 {
            switch indice {
            case 1:
                initChartDetail(typePol: pieChartPolOne)
            case 2:
                initChartDetail(typePol: pieChartPolTwo)
            case 3:
                initChartDetail(typePol: pieChartPolThree)
            case 4:
                initChartDetail(typePol: pieChartPolFour)
            case 5:
                initChartDetail(typePol: pieChartPolFive)
            case 6:
                initChartDetail(typePol: pieChartPolSix)
            default:
                initChartDetail(typePol: pieChartPolOne)
            }
        }
    }

    ///   function initCharts in order to initialize pollutants pie chart
    ///
    private func initChartDetail(typePol: PieChartView) {
        typePol.layer.cornerRadius = 10
        typePol.layer.masksToBounds = false
        typePol.clipsToBounds = true
        typePol.noDataText = ""
        typePol.holeColor = nil
        typePol.legend.enabled = false
        typePol.chartDescription?.text = ""
        typePol.holeRadiusPercent = 0.90
        typePol.rotationAngle = 90
    }

    ///   function fillCityDetail in order to prepare data
    ///
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
        let color = UIColor(named: String(cityDetail[0].qualityColor)) ?? .white
        qualityName.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
        setPollutant()
    }

    ///   function setPollutant in order to prepare data for pollutants
    ///    - loop in measurements
    ///     - call searchValueMaxPollutant in order to have value max of pollutant
    ///     - call updateChartDetail in order to put data of each pollutant
    ///
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            var pollutantValue: Double = 0
            pollutantValue = cityDetail[0].measurements[indice].value
            if cityDetail[0].measurements[indice].unit == "ppm" {
                pollutantValue *= 1000
            }
            let parameter = cityDetail[0].measurements[indice].parameter
            let valueMax =
                searchValueMaxPollutant(parameter: parameter, valueToSearch: pollutantValue)
            updateChartDetail(numPol: indice,
                            pollutantValue: pollutantValue,
                            valueMax: valueMax,
                            parameter: cityDetail[0].measurements[indice].parameter,
                            indiceAtmo: cityDetail[0].measurements[indice].indiceAtmo - 1)
        }
    }

 ///   function searchValueMaxPollutant in order to search pollutant value max by pollutant
 ///
    private func searchValueMaxPollutant(parameter: String, valueToSearch: Double) -> (Double) {
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
        return (value)
    }

    ///   function updateChartDetail in order in order to prepare data for pie chart by pollutant
    ///
    private func updateChartDetail(
        numPol: Int, pollutantValue: Double, valueMax: Double, parameter: String, indiceAtmo: Int) {
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
        let color = UIColor(named: String(QualityLevel.list[indiceAtmo].color))
        typePol.backgroundColor = color
        let raleway = NSUIFont (name: "Raleway", size: 14)
        typePol.centerAttributedText = NSAttributedString(string:
            String(format: "%.0f", pollutantValue),
                attributes: [NSAttributedString.Key.font: raleway!])

        indiceData.value = pollutantValue
        indiceDataFull.value = valueMax - pollutantValue
        indiceDataEntries = [indiceData, indiceDataFull]

        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: colorIndiceData.cgColor),
                      NSUIColor(cgColor: colorIndiceDataFull.cgColor)]

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: colorIndiceData.cgColor))
        chartDataSet.colors = colors
        chartDataSet.label = ""
        typePol.data = chartData
    }
}
