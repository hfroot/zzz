//
//  AdviceDataSource.swift
//  zzz
//
//  Created by user125883 on 3/10/17.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import ResearchKit

class LastNightBaseFloatRangeGraphDataSource:  NSObject, ORKValueRangeGraphChartViewDataSource {
    var plotPoints: [[ORKValueRange]] = [[]]
    var interval: Int = 0
    var maxValue: Int = 0
    
    internal func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 3//plotPoints.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        return plotPoints[plotIndex][pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return plotPoints[plotIndex].count
    }
}

class LastNightLineGraphDataSource: LastNightBaseFloatRangeGraphDataSource {
    
    override init() {
        super.init()
        plotPoints =
            [
                [
                    ORKValueRange(),
                    ORKValueRange(value: 20),
                    ORKValueRange(value: 25),
                    ORKValueRange(value: 30),
                    ORKValueRange(value: 40),
                    ],
                [
                    ORKValueRange(value: 2),
                    ORKValueRange(value: 4),
                    ORKValueRange(value: 8),
                    ORKValueRange(value: 16),
                    ORKValueRange(value: 32),
                    ],
                [
                    ORKValueRange(value: 20),
                    ORKValueRange(value: 25),
                    ORKValueRange(),
                    ORKValueRange(value: 30),
                    ORKValueRange(value: 40),
                    ],
        ]
        
        interval = 10
        maxValue = 50
        
        var timespan: Double = 0
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        
        if let lastNightObj = currentUserData.last{
            let lastNightData = lastNightObj.sensorData
            let startedRecording: Date = (lastNightData.first?.Timestamp)!
            let finishedRecording: Date = (lastNightData.last?.Timestamp)!
            
            timespan = finishedRecording.timeIntervalSince(startedRecording)
            interval = Int((timespan/(60*15)))
            
        }
        
    }
    
    func maximumValueForGraphChartView(_ graphChartView: ORKGraphChartView) -> Double {
        return Double(maxValue)
    }
    
    func minimumValueForGraphChartView(_ graphChartView: ORKGraphChartView) -> Double {
        return 0
    }
    
    func numberOfDivisionsInXAxisForGraphChartView(_ graphChartView: ORKGraphChartView) -> Int {
        return interval
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return nil//(pointIndex % 2 == 0) ? nil : "\(pointIndex + 1)"
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, drawsVerticalReferenceLineAtPointIndex pointIndex: Int) -> Bool {
        return false// (pointIndex % 2 == 1) ? false : true
    }
    
    override func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        
        if let lastNightObj = currentUserData.last{
            let lastNightData = lastNightObj.sensorData
            var index = Int(((pointIndex + 1)*lastNightData.count)/interval)
            if index == lastNightData.count{
                index = index - 1
            }
            var output: Double = 0
            if plotIndex == 0{
                output = Double(lastNightData[index].sensorLight)
            }
            else if plotIndex == 1{
                output = Double(lastNightData[index].sensorHumi)
            }
            else if plotIndex == 2{
                output = Double(lastNightData[index].sensorTemp)
            }
            if Int(output) > maxValue{
                maxValue = Int(output)
            }
            return ORKValueRange(value: output)
        }
        
        return ORKValueRange(value: 0)//plotPoints[plotIndex][pointIndex]
    }
    
    override func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return interval//plotPoints[plotIndex].count
    }
    
    func scrubbingPlotIndexForGraphChartView(_ graphChartView: ORKGraphChartView) -> Int {
        return 0//2
    }
}

class LastNightColoredLineGraphDataSource: LastNightLineGraphDataSource {
    func graphChartView(_ graphChartView: ORKGraphChartView, colorForPlotIndex plotIndex: Int) -> UIColor {
        let color: UIColor
        switch plotIndex {
        case 0:
            color = UIColor.blue
        case 1:
            color = UIColor.red
        case 2:
            color = UIColor.purple
        default:
            color = UIColor.green
        }
        return color
    }
    
    func graphChartView(graphChartView: ORKGraphChartView, fillColorForPlotIndex plotIndex: Int) -> UIColor {
        let color: UIColor
        switch plotIndex {
        case 0:
            color = UIColor.blue.withAlphaComponent(0.1)
        case 1:
            color = UIColor.red.withAlphaComponent(0.1)
        case 2:
            color = UIColor.green.withAlphaComponent(0.1)
        default:
            color = UIColor.cyan.withAlphaComponent(0.1)
        }
        return color
    }
}
