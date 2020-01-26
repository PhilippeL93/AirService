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
        initCharts()
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
        let color = UIColor(named: String(cityDetail[0].qualityColor)) ?? .white
        qualityName.backgroundColor = color
        viewQuality.layer.backgroundColor = color.cgColor
        setPollutant()
    }

    private func setPollutant() {
        for indice in 0...cityDetail[0].measurements.count-1 {
            var pollutantValue: Double = 0
            pollutantValue = cityDetail[0].measurements[indice].value
            if cityDetail[0].measurements[indice].unit == "ppm" {
                pollutantValue *= 1000
            }
            let parameter = cityDetail[0].measurements[indice].parameter
            let (valueMax, indiceAtmo) =
                searchValueMaxPollutant(parameter: parameter, valueToSearch: pollutantValue)
            initChartDetail(numPol: indice,
                            pollutantValue: pollutantValue,
                            valueMax: valueMax,
                            parameter: cityDetail[0].measurements[indice].parameter,
                            indiceAtmo: indiceAtmo)
        }
    }

    private func searchValueMaxPollutant(parameter: String, valueToSearch: Double) -> (Double, Int) {
        var value: Double = 0
        var indiceAtmo: Int = 0
        switch parameter {
        case "co":
            value = CarbonMonoxide.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantCO(value: valueToSearch)
        case "no2":
            value = NitrogenDioxide.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantNO(value: valueToSearch)
        case "o3":
            value = Ozone.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantO(value: valueToSearch)
        case "pm10":
            value = ParticulateTen.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantPMTen(value: valueToSearch)
        case "pm25":
            value = ParticulateTwoFive.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantPMTwoFive(value: valueToSearch)
        case "so2":
            value = SulfurDioxide.list[7].value * 1.5
            indiceAtmo = searchIndicePollutantSO(value: valueToSearch)
        default:
            value = 0
        }
        return (value, indiceAtmo)
    }

    private func initChartDetail(
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

        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueTextColor = (NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor))

        let colors = [NSUIColor(cgColor: UIColor(named: "colorIndiceData")!.cgColor),
                      NSUIColor(cgColor: UIColor(named: "colorIndiceDataFull")!.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.label = ""
        typePol.data = chartData
    }

    /// function searchIndicePollutantCO in order determine level of Carbon Monoxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantCO(value: Double) -> (Int) {
        for indice in 0...CarbonMonoxide.list.count-1
            where value <= CarbonMonoxide.list[indice].value {
                return (indice)
        }
        return (0)
    }

    /// function searchIndicePollutantNO in order determine level of Nitrogen Dioxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantNO(value: Double) -> (Int) {
        for indice in 0...NitrogenDioxide.list.count-1
            where value <= NitrogenDioxide.list[indice].value {
                return (indice)
        }
        return (0)
    }

    /// function searchIndicePollutantO in order determine level of Ozone
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantO(value: Double) -> (Int) {
        for indice in 0...Ozone.list.count-1
            where value <= Ozone.list[indice].value {
                return (indice)
        }
        return (0)
    }

    /// function searchIndicePollutantPMTen in order determine level of PM10
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantPMTen(value: Double) -> (Int) {
        for indice in 0...ParticulateTen.list.count-1
            where value <= ParticulateTen.list[indice].value {
                return (indice)
        }
        return (0)
    }

    /// function searchIndicePollutantPMTwoFive in order determine level of PM2.5
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantPMTwoFive(value: Double) -> (Int) {
        for indice in 0...ParticulateTwoFive.list.count-1
            where value <= ParticulateTwoFive.list[indice].value {
                return (indice)
        }
        return (0)
    }

    /// function searchIndicePollutantSO in order determine level of Sulfur Dioxide
    ///  - loop in structure CarbonMonoxide
    ///     - return indice and value
    ///
    private func searchIndicePollutantSO(value: Double) -> (Int) {
        for indice in 0...SulfurDioxide.list.count-1
            where value <= SulfurDioxide.list[indice].value {
                return (indice)
        }
        return (0)
    }
}
