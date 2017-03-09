//
//  MultiTrackerExample.swift
//  SwiftCharts
//
//  Created by Nate Racklyeft on 6/25/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//

import UIKit
import RealmSwift

class TrendsViewController: UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        getChartDataFromRealm()
        
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
        
//        let data = realm.objects(User.self).filter("name = 'Pierre'")
//        for item in data[0].sensorData {
//            let x = ChartAxisValueDate(date: localDateFormatter.date(from: item.sensorTimestamp)!, formatter: dateFormatter)
//            let y = ChartAxisValueDouble(Double(item.sensorTemp), formatter: decimalFormatter)
//            temperaturePoints.append(ChartPoint(x: x, y: y))
//        }
        
        
    }
    
}
