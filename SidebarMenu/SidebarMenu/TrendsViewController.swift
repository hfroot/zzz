//
//  MultiTrackerExample.swift
//  SwiftCharts
//
//  Created by Nate Racklyeft on 6/25/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts
import RealmSwift

// Configuration
private extension UIColor {
    static let secondaryLabelColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
    
    static let gridColor = UIColor(white: 193 / 255, alpha: 1)
    
    static let glucoseTintColor = UIColor(red: 96 / 255, green: 201 / 255, blue: 248 / 255, alpha: 1)
    
    static let IOBTintColor: UIColor = UIColor(red: 254 / 255, green: 149 / 255, blue: 38 / 255, alpha: 1)
}

private let dateFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    
    return timeFormatter
}()

private let localDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter
}()

private let decimalFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    
    return numberFormatter
}()

// MARK – Fixture data

private let glucosePoints: [ChartPoint] = [("28-02-2016  07:26:38", 95), ("28-02-2016  07:31:38", 93), ("28-02-2016  07:41:39", 92), ("28-02-2016  07:51:42", 92), ("28-02-2016  07:56:38", 94), ("28-02-2016  08:01:39", 94), ("28-02-2016  08:06:38", 95), ("28-02-2016  08:11:37", 95), ("28-02-2016  08:16:40", 100), ("28-02-2016  08:21:39", 99), ("28-02-2016  08:26:39", 99), ("28-02-2016  08:31:38", 97), ("28-02-2016  08:51:43", 101), ("28-02-2016  08:56:39", 105), ("28-02-2016  09:01:43", 101), ("28-02-2016  09:06:37", 102), ("28-02-2016  09:11:37", 107), ("28-02-2016  09:16:38", 109), ("28-02-2016  09:21:37", 113), ("28-02-2016  09:26:41", 114), ("28-02-2016  09:31:37", 112), ("28-02-2016  09:36:39", 111), ("28-02-2016  09:41:40", 111), ("28-02-2016  09:46:43", 112), ("28-02-2016  09:51:38", 113), ("28-02-2016  09:56:43", 112), ("28-02-2016  10:01:38", 111), ("28-02-2016  10:06:42", 112), ("28-02-2016  10:11:37", 115), ("28-02-2016  10:16:42", 119), ("28-02-2016  10:21:42", 121), ("28-02-2016  10:26:38", 127), ("28-02-2016  10:31:36", 129), ("28-02-2016  10:36:37", 132), ("28-02-2016  10:41:38", 135), ("28-02-2016  10:46:37", 138), ("28-02-2016  10:51:36", 137), ("28-02-2016  10:56:38", 141), ("28-02-2016  11:01:37", 146), ("28-02-2016  11:06:40", 151), ("28-02-2016  11:16:37", 163), ("28-02-2016  11:21:36", 169), ("28-02-2016  11:26:37", 177), ("28-02-2016  11:31:37", 183), ("28-02-2016  11:36:37", 187), ("28-02-2016  11:41:36", 190), ("28-02-2016  11:46:36", 192), ("28-02-2016  11:51:36", 194), ("28-02-2016  11:56:36", 194), ("28-02-2016  12:01:37", 192), ("28-02-2016  12:06:41", 192), ("28-02-2016  12:11:36", 183), ("28-02-2016  12:16:38", 176), ("28-02-2016  12:21:39", 165), ("28-02-2016  12:26:38", 156), ("28-02-2016  12:31:37", 144), ("28-02-2016  12:36:36", 138), ("28-02-2016  12:41:37", 131), ("28-02-2016  12:46:37", 125), ("28-02-2016  12:51:36", 118), ("28-02-2016  13:01:43", 104), ("28-02-2016  13:06:45", 97), ("28-02-2016  13:11:39", 92), ("28-02-2016  13:16:37", 88), ("28-02-2016  13:21:36", 88)].map {
    return ChartPoint(
        x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.0)!, formatter: dateFormatter),
        y: ChartAxisValueInt($0.1)
    )
}

private let predictedGlucosePoints: [ChartPoint] = [("28-02-2016  13:21:36", 88), ("28-02-2016  13:25:00", 87), ("28-02-2016  13:30:00", 85), ("28-02-2016  13:35:00", 83), ("28-02-2016  13:40:00", 81), ("28-02-2016  13:45:00", 81), ("28-02-2016  13:50:00", 81), ("28-02-2016  13:55:00", 83), ("28-02-2016  14:00:00", 84), ("28-02-2016  14:05:00", 87), ("28-02-2016  14:10:00", 90), ("28-02-2016  14:15:00", 93), ("28-02-2016  14:20:00", 97), ("28-02-2016  14:25:00", 102), ("28-02-2016  14:30:00", 107), ("28-02-2016  14:35:00", 113), ("28-02-2016  14:40:00", 120), ("28-02-2016  14:45:00", 128), ("28-02-2016  14:50:00", 136), ("28-02-2016  14:55:00", 145), ("28-02-2016  15:00:00", 154), ("28-02-2016  15:05:00", 163), ("28-02-2016  15:10:00", 172), ("28-02-2016  15:15:00", 179), ("28-02-2016  15:20:00", 187), ("28-02-2016  15:25:00", 194), ("28-02-2016  15:30:00", 200), ("28-02-2016  15:35:00", 206), ("28-02-2016  15:40:00", 211), ("28-02-2016  15:45:00", 215), ("28-02-2016  15:50:00", 219), ("28-02-2016  15:55:00", 223), ("28-02-2016  16:00:00", 226), ("28-02-2016  16:05:00", 228), ("28-02-2016  16:10:00", 230), ("28-02-2016  16:15:00", 231), ("28-02-2016  16:20:00", 231), ("28-02-2016  16:25:00", 231), ("28-02-2016  16:30:00", 230), ("28-02-2016  16:35:00", 230), ("28-02-2016  16:40:00", 229), ("28-02-2016  16:45:00", 228), ("28-02-2016  16:50:00", 227), ("28-02-2016  16:55:00", 226), ("28-02-2016  17:00:00", 225), ("28-02-2016  17:05:00", 224), ("28-02-2016  17:10:00", 224), ("28-02-2016  17:15:00", 223), ("28-02-2016  17:20:00", 222), ("28-02-2016  17:25:00", 221), ("28-02-2016  17:30:00", 221), ("28-02-2016  17:35:00", 220), ("28-02-2016  17:40:00", 219), ("28-02-2016  17:45:00", 219), ("28-02-2016  17:50:00", 218), ("28-02-2016  17:55:00", 218), ("28-02-2016  18:00:00", 218), ("28-02-2016  18:05:00", 218), ("28-02-2016  18:10:00", 218)].map {
    return ChartPoint(
        x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.0)!, formatter: dateFormatter),
        y: ChartAxisValueInt($0.1)
    )
}

private let IOBPoints: [ChartPoint] = [("28-02-2016  07:25:00", 0.0), ("28-02-2016  07:30:00", 0.0036944444444472783), ("28-02-2016  07:35:00", -0.041666666666665263), ("28-02-2016  07:40:00", -0.11298963260090503), ("28-02-2016  07:45:00", -0.18364018193611475), ("28-02-2016  07:50:00", -0.17905627846292443), ("28-02-2016  07:55:00", -0.19834382681098695), ("28-02-2016  08:00:00", -0.19192177354344478), ("28-02-2016  08:05:00", -0.18546870465908208), ("28-02-2016  08:10:00", -0.17906574601611175), ("28-02-2016  08:15:00", -0.17135469795520025), ("28-02-2016  08:20:00", -0.16450124880944814), ("28-02-2016  08:25:00", -0.18095248614585058), ("28-02-2016  08:30:00", -0.17286981664792092), ("28-02-2016  08:35:00", -0.1649428517240436), ("28-02-2016  08:40:00", -0.15630024940346263), ("28-02-2016  08:45:00", -0.15564973761315049), ("28-02-2016  08:50:00", -0.15484465042603354), ("28-02-2016  08:55:00", -0.15385632304648592), ("28-02-2016  09:00:00", -0.14503406786881623), ("28-02-2016  09:05:00", -0.13560430142200144), ("28-02-2016  09:10:00", 4.1236760598368143), ("28-02-2016  09:15:00", 4.7580045858653408), ("28-02-2016  09:20:00", 4.797507610088223), ("28-02-2016  09:25:00", 4.7470649930859192), ("28-02-2016  09:30:00", 4.8073808321227238), ("28-02-2016  09:35:00", 4.7574313425927555), ("28-02-2016  09:40:00", 4.6956867789037213), ("28-02-2016  09:45:00", 4.6245111681877402), ("28-02-2016  09:50:00", 4.5433444176942741), ("28-02-2016  09:55:00", 4.431270599886326), ("28-02-2016  10:00:00", 4.3347991573984439), ("28-02-2016  10:05:00", 4.232130329715214), ("28-02-2016  10:10:00", 4.123473669887483), ("28-02-2016  10:15:00", 4.1849607740674131), ("28-02-2016  10:20:00", 4.2908357326261486), ("28-02-2016  10:25:00", 4.3923300950301805), ("28-02-2016  10:30:00", 4.4880804898394571), ("28-02-2016  10:35:00", 4.5795239011041415), ("28-02-2016  10:40:00", 4.6167066079119099), ("28-02-2016  10:45:00", 4.648763226113056), ("28-02-2016  10:50:00", 4.5757548336618656), ("28-02-2016  10:55:00", 4.5483941239244547), ("28-02-2016  11:00:00", 4.4669082248258229), ("28-02-2016  11:05:00", 4.3572781110626684), ("28-02-2016  11:10:00", 4.2448651414495249), ("28-02-2016  11:15:00", 4.1302836952228299), ("28-02-2016  11:20:00", 4.8644613141889321), ("28-02-2016  11:25:00", 4.7735479450092804), ("28-02-2016  11:30:00", 4.6763723172632066), ("28-02-2016  11:35:00", 4.6263678363933698), ("28-02-2016  11:40:00", 4.6252248376336471), ("28-02-2016  11:45:00", 4.6715820280965836), ("28-02-2016  11:50:00", 4.6657775819812244), ("28-02-2016  11:55:00", 4.6070572580733025), ("28-02-2016  12:00:00", 4.3991804144755005), ("28-02-2016  12:05:00", 4.2207285890562476), ("28-02-2016  12:10:00", 4.0174866626399064), ("28-02-2016  12:15:00", 3.8273922804263738), ("28-02-2016  12:20:00", 3.6385602030825925), ("28-02-2016  12:25:00", 3.3894133230689309), ("28-02-2016  12:30:00", 3.1420958613914309), ("28-02-2016  12:35:00", 2.8973159487084286), ("28-02-2016  12:40:00", 2.6562913087973756), ("28-02-2016  12:45:00", 2.4197470432113661), ("28-02-2016  12:50:00", 2.1866578462641546), ("28-02-2016  12:55:00", 1.9592879884763279), ("28-02-2016  13:00:00", 1.7368620414389135), ("28-02-2016  13:05:00", 1.5198636712336329), ("28-02-2016  13:10:00", 1.3089436183182606), ("28-02-2016  13:15:00", 1.1535104030437469), ("28-02-2016  13:20:00", 1.029259238414155), ("28-02-2016  13:25:00", 0.92424875183689581), ("28-02-2016  13:30:00", 1.0693214999513172), ("28-02-2016  13:35:00", 1.2179252372806773), ("28-02-2016  13:40:00", 1.3686107583250724), ("28-02-2016  13:45:00", 1.5216601122146722), ("28-02-2016  13:50:00", 1.6756373722393785), ("28-02-2016  13:55:00", 1.830049276750918), ("28-02-2016  14:00:00", 1.7552739393101593), ("28-02-2016  14:05:00", 1.6800326149026008), ("28-02-2016  14:10:00", 1.6045615612089266), ("28-02-2016  14:15:00", 1.529552685984469), ("28-02-2016  14:20:00", 1.4551922972209459), ("28-02-2016  14:25:00", 1.3816704659238352), ("28-02-2016  14:30:00", 1.3106997507187577), ("28-02-2016  14:35:00", 1.2427108235823778), ("28-02-2016  14:40:00", 1.1777114790667285), ("28-02-2016  14:45:00", 1.1156548582553669), ("28-02-2016  14:50:00", 1.0565416809216186), ("28-02-2016  14:55:00", 0.99991680907617442), ("28-02-2016  15:00:00", 0.94574181090268616), ("28-02-2016  15:05:00", 0.89311904821375931), ("28-02-2016  15:10:00", 0.84250915821388683), ("28-02-2016  15:15:00", 0.79345730299880946), ("28-02-2016  15:20:00", 0.74576518876929832), ("28-02-2016  15:25:00", 0.69945200554164288), ("28-02-2016  15:30:00", 0.65458567086334363), ("28-02-2016  15:35:00", 0.61866148080393324), ("28-02-2016  15:40:00", 0.58390071320767833), ("28-02-2016  15:45:00", 0.55029240045115302), ("28-02-2016  15:50:00", 0.51829806202973916), ("28-02-2016  15:55:00", 0.48838055766253852), ("28-02-2016  16:00:00", 0.46089759917798961), ("28-02-2016  16:05:00", 0.43533222555553236), ("28-02-2016  16:10:00", 0.41120094219970449), ("28-02-2016  16:15:00", 0.38717483135971792), ("28-02-2016  16:20:00", 0.36362072793021766), ("28-02-2016  16:25:00", 0.34038412512290156), ("28-02-2016  16:30:00", 0.31764547529085824), ("28-02-2016  16:35:00", 0.29545546750125873), ("28-02-2016  16:40:00", 0.27331799993023986), ("28-02-2016  16:45:00", 0.25131871047913684), ("28-02-2016  16:50:00", 0.22953602018938493), ("28-02-2016  16:55:00", 0.20804019837577364), ("28-02-2016  17:00:00", 0.18689329832809301), ("28-02-2016  17:05:00", 0.16615003800600928), ("28-02-2016  17:10:00", 0.14585543305215659), ("28-02-2016  17:15:00", 0.12604606271228064), ("28-02-2016  17:20:00", 0.10674921606115091), ("28-02-2016  17:25:00", 0.08799217115883326), ("28-02-2016  17:30:00", 0.070225506888435554), ("28-02-2016  17:35:00", 0.053631040821926462), ("28-02-2016  17:40:00", 0.037669241351902909), ("28-02-2016  17:45:00", 0.02475357068905246), ("28-02-2016  17:50:00", 0.014701054938544136), ("28-02-2016  17:55:00", 0.007335418533029334), ("28-02-2016  18:00:00", 0.0024882220451422584), ("28-02-2016  18:05:00", 0.0), ("28-02-2016  18:10:00", 0.0)].map {
    return ChartPoint(
        x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.0)!, formatter: dateFormatter),
        y: ChartAxisValueDouble($0.1, formatter: decimalFormatter)
    )
}


class TrendsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    fileprivate var topChart: Chart?
    
    fileprivate var bottomChart: Chart?
    
    fileprivate lazy private(set) var chartPanGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: – Chart configuration
    
    fileprivate lazy private(set) var chartSettings: ChartSettings = {
        var chartSettings = ChartSettings()
        chartSettings.top = 12
        chartSettings.bottom = 0
        chartSettings.trailing = 8
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.labelsToAxisSpacingX = 6
        return chartSettings
    }()
    
    private let axisLabelSettings: ChartLabelSettings = ChartLabelSettings()
    
    private let guideLinesLayerSettings: ChartGuideLinesLayerSettings = ChartGuideLinesLayerSettings()
    
    fileprivate lazy private(set) var axisLineColor = UIColor.clear
    
    fileprivate var xAxisValues: [ChartAxisValue]? {
        didSet {
            if let xAxisValues = xAxisValues {
                xAxisModel = ChartAxisModel(axisValues: xAxisValues, lineColor: axisLineColor)
            } else {
                xAxisModel = nil
            }
        }
    }
    
    fileprivate var xAxisModel: ChartAxisModel?
    
    fileprivate var temperaturePoints: [ChartPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        chartPanGestureRecognizer.delegate = self
        view.addGestureRecognizer(chartPanGestureRecognizer)
        
        getChartDataFromRealm()
        
        generateXAxisValues()
        
        let fullFrame = ExamplesDefaults.chartFrame(view.bounds)
        let (topFrame, bottomFrame) = fullFrame.divided(atDistance: fullFrame.height / 2, from: .minYEdge)
        
        topChart = generateGlucoseChartWithFrame(topFrame)
        bottomChart = generateIOBChartWithFrame(frame: bottomFrame)
        
        for chart in [topChart, bottomChart] {
            if let view = chart?.view {
                self.view.addSubview(view)
            }
        }
    }
    
    func getChartDataFromRealm() {
        
//        let data = realm.objects(User.self).filter("name = 'Pierre'")
//        var tempPoints: [(x:String, y:Float)] = []
//        for item in data[0].sensorData {
//            tempPoints.append((item.sensorTimestamp, item.sensorTemp))
//        }
//
//        temperaturePoints = [tempPoints].map {
//            return ChartPoint(
//                x: ChartAxisValueDate(date: localDateFormatter.date(from: $0[0].x)!, formatter: dateFormatter),
//                y: ChartAxisValueDouble(Double($0[0].y), formatter: decimalFormatter)
//            )
//        }
        
        let data = realm.objects(User.self).filter("name = 'Pierre'")
        for item in data[0].sensorData {
            let x = ChartAxisValueDate(date: localDateFormatter.date(from: item.sensorTimestamp)!, formatter: dateFormatter)
            let y = ChartAxisValueDouble(Double(item.sensorTemp), formatter: decimalFormatter)
            temperaturePoints.append(ChartPoint(x: x, y: y))
        }
        
        
    }
    
    fileprivate func generateXAxisValues() {
        let points = temperaturePoints //glucosePoints + predictedGlucosePoints
        
        guard points.count > 1 else {
            self.xAxisValues = []
            return
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h a"
        
        let xAxisValues = ChartAxisValuesStaticGenerator.generateXAxisValuesWithChartPoints(points, minSegmentCount: 5, maxSegmentCount: 10, multiple: TimeInterval(60 * 60), axisValueGenerator: { ChartAxisValueDate(date: ChartAxisValueDate.dateFromScalar($0), formatter: timeFormatter, labelSettings: axisLabelSettings)
        }, addPaddingSegmentIfEdge: false)
        xAxisValues.first?.hidden = true
        xAxisValues.last?.hidden = true
        
        self.xAxisValues = xAxisValues
    }
    
    fileprivate func generateGlucoseChartWithFrame(_ frame: CGRect) -> Chart? {
        guard temperaturePoints.count > 1, let xAxisModel = xAxisModel else {
            return nil
        }
        
        let allPoints = temperaturePoints
        
        // TODO: The segment/multiple values are unit-specific
        let yAxisValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(allPoints, minSegmentCount: 2, maxSegmentCount: 4, multiple: 25, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: axisLabelSettings)}, addPaddingSegmentIfEdge: true)
        
        let yAxisModel = ChartAxisModel(axisValues: yAxisValues, lineColor: axisLineColor)
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xAxisModel, yModel: yAxisModel)
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let gridLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: .x, settings: guideLinesLayerSettings)
        
        let circles = ChartPointsScatterCirclesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: temperaturePoints, displayDelay: 0, itemSize: CGSize(width: 4, height: 4), itemFillColor: UIColor.glucoseTintColor)
        
        var prediction: ChartLayer?
        
        if predictedGlucosePoints.count > 1 {
            prediction = ChartPointsScatterCirclesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: predictedGlucosePoints, displayDelay: 0, itemSize: CGSize(width: 2, height: 2), itemFillColor: UIColor.glucoseTintColor.withAlphaComponent(0.75))
        }
        
        let highlightLayer = ChartPointsTouchHighlightLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            chartPoints: allPoints,
            tintColor: UIColor.glucoseTintColor,
            labelCenterY: chartSettings.top,
            gestureRecognizer: chartPanGestureRecognizer
        )
        
        let layers: [ChartLayer?] = [
            gridLayer,
            xAxisLayer,
            yAxisLayer,
            highlightLayer,
            prediction,
            circles
        ]
        
        return Chart(frame: frame, innerFrame: innerFrame, settings: chartSettings, layers: layers.flatMap { $0 })
    }
    
    private func generateIOBChartWithFrame(frame: CGRect) -> Chart? {
        guard IOBPoints.count > 1, let xAxisModel = xAxisModel else {
            return nil
        }
        
        var containerPoints = IOBPoints
        
        // Create a container line at 0
        if let first = IOBPoints.first {
            containerPoints.insert(ChartPoint(x: first.x, y: ChartAxisValueInt(0)), at: 0)
        }
        
        if let last = IOBPoints.last {
            containerPoints.append(ChartPoint(x: last.x, y: ChartAxisValueInt(0)))
        }
        
        let yAxisValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(IOBPoints, minSegmentCount: 2, maxSegmentCount: 3, multiple: 0.5, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: axisLabelSettings)}, addPaddingSegmentIfEdge: false)
        
        let yAxisModel = ChartAxisModel(axisValues: yAxisValues, lineColor: axisLineColor, labelSpaceReservationMode: .fixed(30))
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xAxisModel, yModel: yAxisModel)
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        let (xAxis, yAxis) = (xAxisLayer.axis, yAxisLayer.axis)
        
        // The IOB area
        let lineModel = ChartLineModel(chartPoints: IOBPoints, lineColor: UIColor.IOBTintColor, lineWidth: 2, animDuration: 0, animDelay: 0)
        let IOBLine = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, lineModels: [lineModel])
        
        let IOBArea = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: containerPoints, areaColor: UIColor.IOBTintColor.withAlphaComponent(0.5), animDuration: 0, animDelay: 0, addContainerPoints: false)
        
        // Grid lines
        let gridLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: .xAndY, settings: guideLinesLayerSettings)
        
        // 0-line
        let dummyZeroChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let zeroGuidelineLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: [dummyZeroChartPoint], viewGenerator: {(chartPointModel, layer, chart, _) -> UIView? in
            let width: CGFloat = 0.5
            let viewFrame = CGRect(x: innerFrame.origin.x, y: chartPointModel.screenLoc.y - width / 2, width: innerFrame.size.width, height: width)
            
            let v = UIView(frame: viewFrame)
            v.backgroundColor = UIColor.IOBTintColor
            return v
        })
        
        let highlightLayer = ChartPointsTouchHighlightLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            chartPoints: IOBPoints,
            tintColor: UIColor.IOBTintColor,
            labelCenterY: chartSettings.top,
            gestureRecognizer: chartPanGestureRecognizer
        )
        
        let layers: [ChartLayer?] = [
            gridLayer,
            xAxisLayer,
            yAxisLayer,
            zeroGuidelineLayer,
            highlightLayer,
            IOBArea,
            IOBLine,
            ]
        
        return Chart(frame: frame, innerFrame: innerFrame, settings: chartSettings, layers: layers.flatMap { $0 })
    }
}


/*
 Here we extend ChartPointsTouchHighlightLayer to contain its initialization
 */
private extension ChartPointsTouchHighlightLayer {
    
    convenience init(
        xAxisLayer: ChartAxisLayer,
        yAxisLayer: ChartAxisLayer,
        chartPoints: [T],
        tintColor: UIColor,
        labelCenterY: CGFloat = 0,
        gestureRecognizer: UIPanGestureRecognizer? = nil
        ) {
        self.init(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, gestureRecognizer: gestureRecognizer,
                  modelFilter: { (screenLoc, chartPointModels) -> ChartPointLayerModel<T>? in
                    if let index = chartPointModels.map({ $0.screenLoc.x }).findClosestElementIndexToValue(screenLoc.x) {
                        return chartPointModels[index]
                    } else {
                        return nil
                    }
        },
                  viewGenerator: { (chartPointModel, layer, chart, isTransform) -> U? in
                    let containerView = U(frame: chart.view.bounds)
                    
                    let xAxisOverlayView = UIView(frame: xAxisLayer.frame.offsetBy(dx: 0, dy: 1))
                    xAxisOverlayView.backgroundColor = UIColor.white
                    xAxisOverlayView.isOpaque = true
                    containerView.addSubview(xAxisOverlayView)
                    
                    let point = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 16)
                    point.fillColor = tintColor.withAlphaComponent(0.5)
                    containerView.addSubview(point)
                    
                    if let text = chartPointModel.chartPoint.y.labels.first?.text {
                        let label = UILabel()
                        if #available(iOS 9.0, *) {
                            label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFontWeightBold)
                        } else {
                            label.font = UIFont.systemFont(ofSize: 15)
                        }
                        
                        label.text = text
                        label.textColor = tintColor
                        label.textAlignment = .center
                        label.sizeToFit()
                        label.frame.size.height += 4
                        label.frame.size.width += label.frame.size.height / 2
                        label.center.y = chart.containerView.frame.origin.y - 1
                        label.center.x = chartPointModel.screenLoc.x
                        label.frame.origin.x = min(max(label.frame.origin.x, chart.containerView.frame.origin.x), chart.containerView.frame.maxX - label.frame.size.width)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        label.layer.borderColor = tintColor.cgColor
                        label.layer.borderWidth = 1 / chart.view.traitCollection.displayScale
                        label.layer.cornerRadius = label.frame.size.height / 2
                        label.backgroundColor = UIColor.white
                        
                        containerView.addSubview(label)
                    }
                    
                    if let text = chartPointModel.chartPoint.x.labels.first?.text {
                        let label = UILabel()
                        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
                        label.text = text
                        label.textColor = UIColor.secondaryLabelColor
                        label.sizeToFit()
                        label.center = CGPoint(x: chartPointModel.screenLoc.x, y: xAxisOverlayView.center.y)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        
                        containerView.addSubview(label)
                    }
                    
                    return containerView
        }
        )
    }
}


private extension CGPoint {
    /**
     Rounds the coordinates to whole-pixel values
     
     - parameter scale: The display scale to use. Defaults to the main screen scale.
     */
    mutating func makeIntegralInPlaceWithDisplayScale(_ scale: CGFloat = 0) {
        var scale = scale
        
        // It's possible for scale values retrieved from traitCollection objects to be 0.
        if scale == 0 {
            scale = UIScreen.main.scale
        }
        x = round(x * scale) / scale
        y = round(y * scale) / scale
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Comparable, Index.Stride == Int {
    
    /**
     Returns the insertion index of a new value in a sorted collection
     
     Based on some helpful responses found at [StackOverflow](http://stackoverflow.com/a/33674192)
     
     - parameter value: The value to insert
     
     - returns: The appropriate insertion index, between `startIndex` and `endIndex`
     */
    func findInsertionIndexForValue(_ value: Iterator.Element) -> Index {
        var low = startIndex
        var high = endIndex
        
        while low != high {
            let mid = low.advanced(by: low.distance(to: high) / 2)
            
            if self[mid] < value {
                low = mid.advanced(by: 1)
            } else {
                high = mid
            }
        }
        
        return low
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Strideable, Index.Stride == Int {
    /**
     Returns the index of the closest element to a specified value in a sorted collection
     
     - parameter value: The value to match
     
     - returns: The index of the closest element, or nil if the collection is empty
     */
    func findClosestElementIndexToValue(_ value: Iterator.Element) -> Index? {
        let upperBound = findInsertionIndexForValue(value)
        
        if upperBound == startIndex {
            if upperBound == endIndex {
                return nil
            }
            return upperBound
        }
        
        let lowerBound = upperBound.advanced(by: -1)
        
        if upperBound == endIndex {
            return lowerBound
        }
        
        if value.distance(to: self[upperBound]) < self[lowerBound].distance(to: value) {
            return upperBound
        }
        
        return lowerBound
    }
}
