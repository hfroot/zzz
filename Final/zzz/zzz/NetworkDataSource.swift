//
//  NetworkDataSource.swift
//  zzz
//
//  Created by user125883 on 3/10/17.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import ResearchKit

let NetworkNumberOfPieChartSegments = 3

var networkPieChartValues: [CGFloat] = [CGFloat(0.6),
                                        CGFloat(0.6),
                                        CGFloat(0.5)]

let networkPieChartColours: [UIColor] = [UIColor(red: 1, green: 0, blue: 0, alpha: 1),
                                         UIColor(red: 0, green: 0, blue: 1, alpha: 1),
                                         UIColor(red: 0, green: 1, blue: 0, alpha: 1)]

func updateNetworkPieChartValues(newValues: [CGFloat]){
    networkPieChartValues = newValues
}

class NetworkColorlessPieChartDataSource: NSObject, ORKPieChartViewDataSource {
    
    func numberOfSegments(in pieChartView: ORKPieChartView ) -> Int {
        return NetworkNumberOfPieChartSegments
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        return networkPieChartValues[index]
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

class NetworkPieChartDataSource: NetworkColorlessPieChartDataSource {
    
    func pieChartView(_ pieChartView: ORKPieChartView, colorForSegmentAtIndex index: Int) -> UIColor {
        return networkPieChartColours[index]
    }
}
