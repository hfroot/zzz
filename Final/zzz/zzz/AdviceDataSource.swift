//
//  AdviceDataSource.swift
//  zzz
//
//  Created by user125883 on 3/10/17.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import ResearchKit

func createRandomColorArray(_ number: Int) -> [UIColor] {
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    var colors: [UIColor] = []
    for _ in 0 ..< number {
        colors.append(UIColor(red: random(), green: random(), blue: random(), alpha: 1))
    }
    return colors
}

let AdviceNumberOfPieChartSegments = 13

var pieChartValues: [CGFloat] = [CGFloat(0.6),
                         CGFloat(0.6),
                         CGFloat(0.5),
                         CGFloat(0.3),
                         CGFloat(0.4),
                         CGFloat(0.4),
                         CGFloat(0.3),
                         CGFloat(0.6),
                         CGFloat(0.6),
                         CGFloat(0.5),
                         CGFloat(0.5),
                         CGFloat(0.3),
                         CGFloat(0.5)]

let pieChartColours: [UIColor] = [UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                                 UIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                 UIColor(red: 0, green: 0, blue: 1, alpha: 1),
                                 UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1),
                                 UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1),
                                 UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 1),
                                 UIColor(red: 0.4, green: 0.3, blue: 0.3, alpha: 1),
                                 UIColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1),
                                 UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1),
                                 UIColor(red: 0.5, green: 0.3, blue: 0.2, alpha: 1),
                                 UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1),
                                 UIColor(red: 0.3, green: 0.2, blue: 0.5, alpha: 1),
                                 UIColor(red: 0.5, green: 0.2, blue: 0.3, alpha: 1)]

func updatePieChartValues(newValues: [CGFloat]){
    pieChartValues = newValues
}

class AdviceColorlessPieChartDataSource: NSObject, ORKPieChartViewDataSource {
    
    func numberOfSegments(in pieChartView: ORKPieChartView ) -> Int {
        return AdviceNumberOfPieChartSegments
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        return pieChartValues[index]
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, titleForSegmentAt index: Int) -> String {
        switch index{
        case 0:
            return "duration"
        case 1:
            return "exercise"
        case 2:
            return "caffeine"
        case 3:
            return "meal"
        case 4:
            return "nicotine"
        case 5:
            return "alcohol"
        case 6:
            return "relaxation"
        case 7:
            return "light"
        case 8:
            return "noise"
        case 9:
            return "heat"
        case 10:
            return "cold"
        case 11:
            return "humidity"
        case 12:
            return "device"
        default:
            return "other"
        }
    }
}

class AdvicePieChartDataSource: AdviceColorlessPieChartDataSource {
    
    //lazy var backingStore: [UIColor] = {
        //return createRandomColorArray(NumberOfPieChartSegments)
    //}()
    
    func pieChartView(_ pieChartView: ORKPieChartView, colorForSegmentAtIndex index: Int) -> UIColor {
        return pieChartColours[index]
    }
}
