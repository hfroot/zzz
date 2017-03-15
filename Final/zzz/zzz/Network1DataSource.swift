//
//  NetworkDataSource.swift
//  zzz
//
//  Created by user125883 on 3/10/17.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import ResearchKit

let Network1NumberOfPieChartSegments = 3

var network1PieChartValues: [CGFloat] = [CGFloat(0.6),
                                        CGFloat(0.6),
                                        CGFloat(0.5)]

let network1PieChartColours: [UIColor] = [UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                                         UIColor(red: 0, green: 0, blue: 1, alpha: 1),
                                         UIColor(red: 0, green: 1, blue: 0, alpha: 1)]

func updateNetwork1PieChartValues(newValues: [CGFloat]){
    network1PieChartValues = newValues
}

class Network1ColorlessPieChartDataSource: NSObject, ORKPieChartViewDataSource {
    
    func numberOfSegments(in pieChartView: ORKPieChartView ) -> Int {
        return Network1NumberOfPieChartSegments
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        return network1PieChartValues[index]
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, titleForSegmentAt index: Int) -> String {
        switch index{
        case 0:
            return "slept well"
        case 1:
            return "didn't sleep well"
        case 2:
            return "n/a"
        default:
            return "n/a"
        }
    }
}

class Network1PieChartDataSource: Network1ColorlessPieChartDataSource {
    
    func pieChartView(_ pieChartView: ORKPieChartView, colorForSegmentAtIndex index: Int) -> UIColor {
        return network1PieChartColours[index]
    }
}
