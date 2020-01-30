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

    @IBOutlet weak var qualityView: UIView!
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
        guard let raleway = NSUIFont (name: "Raleway", size: 22) else {
            return
        }
        pieChart.centerAttributedText = NSAttributedString(string:
            String(format: "%.0f", cityDetail[0].qualityIndicator),
                attributes: [NSAttributedString.Key.font: raleway])
        indiceData.value = cityDetail[0].qualityIndicator
        indiceDataFull.value = 200 - cityDetail[0].qualityIndicator
        indiceDataEntries = [indiceData, indiceDataFull]
        updateMainChartData()
    }

    ///   function updateMainChartData in order to prepare data for main pie chart
    ///
    private func updateMainChartData() {
        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: colorIndiceData.cgColor),
                      NSUIColor(cgColor: colorIndiceDataFull.cgColor)]

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: colorIndiceData.cgColor))
        chartDataSet.colors = colors
        chartDataSet.label = ""
        chartDataSet.selectionShift = 0
        pieChart.data = chartData
    }

    ///   function initCharts in order to initialize pollutants pie chart
    ///
    private func initCharts() {

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
        typePol.backgroundColor = .white
    }

    ///   function fillCityDetail in order to prepare data
    ///
    private func fillCityDetail() {
        cityName.text = cityDetail[0].city
        department.text = cityDetail[0].location
        if cityDetail[0].country == "DE" {
            department.text = cityDetail[0].locations
            if cityDetail[0].locations.isEmpty {
                department.text = locationsName
            }
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
        qualityView.layer.backgroundColor = color.cgColor
        setPollutant()
    }

    ///   function setPollutant in order to prepare data for pollutants
    ///    - loop in measurements
    ///     - call updateChartDetail in order to put data of each pollutant
    ///
    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            var pollutantValue: Double = 0
            pollutantValue = cityDetail[0].measurements[indice].value
            if cityDetail[0].measurements[indice].unit == "ppm" {
                pollutantValue *= 1000
            }
            let typePol = defineTypePol(parameter: cityDetail[0].measurements[indice].parameter, numPol: indice)
            updateChartDetail(typePol: typePol,
                                 pollutantValue: pollutantValue,
                                 valueMax: cityDetail[0].measurements[indice].valueMax,
                                 indiceAtmo: cityDetail[0].measurements[indice].indiceAtmo - 1,
                                 valueMin: cityDetail[0].measurements[indice].valueMin)
        }
    }

    ///   function updateChartDetail in order in order to prepare data for pie chart by pollutant
    ///
    private func updateChartDetail(
        typePol: PieChartView, pollutantValue: Double, valueMax: Double, indiceAtmo: Int, valueMin: Double) {

        typePol.layer.borderWidth = 1
        typePol.layer.borderColor = #colorLiteral(red: 0.752874434, green: 0.7529839873, blue: 0.7528504729, alpha: 1)

        guard let color = UIColor(named: String(QualityLevel.list[indiceAtmo].color)) else {
            return
        }
        guard let raleway = NSUIFont (name: "Raleway", size: 14) else {
            return
        }
        typePol.centerAttributedText = NSAttributedString(string:
            String(format: "%.1f", pollutantValue),
                attributes: [NSAttributedString.Key.font: raleway])
        if pollutantValue < valueMin && pollutantValue != 0 {
            indiceData.value = valueMin
        } else {
            indiceData.value = pollutantValue
        }
        indiceDataFull.value = valueMax - pollutantValue
        indiceDataEntries = [indiceData, indiceDataFull]
        let chartDataSet = PieChartDataSet(entries: indiceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: color.cgColor),
                      NSUIColor(cgColor: colorIndiceDataFull.cgColor)]
        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: colorIndiceData.cgColor))
        chartDataSet.colors = colors
        chartDataSet.label = ""
        chartDataSet.selectionShift = 8
        typePol.data = chartData
    }

    private func defineTypePol(parameter: String, numPol: Int) -> PieChartView {
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
        return typePol
    }
}
