//
//  ViewController.swift
//  zzz
//
//  Created by user125883 on 3/9/17.
//  Copyright © 2017 Julia Booth. All rights reserved.
//

import UIKit
import ResearchKit

class LastNightViewController: UIViewController {
    
    
    @IBOutlet weak var lastNightLabel: UILabel!
    
    @IBOutlet weak var lastNightLineGraphView: ORKLineGraphChartView!
    
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var lightAverageLabel: UILabel!
    @IBOutlet weak var humidityAverageLabel: UILabel!
    @IBOutlet weak var temperatureAverageLabel: UILabel!
    
    let lastNightLineGraphDataSource = LastNightColoredLineGraphDataSource()
    let lastNightLineGraphIdentifier = "LineGraph"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastNightLineGraphView?.dataSource = lastNightLineGraphDataSource
        lastNightLineGraphView.tintColor = UIColor.white
        lastNightLineGraphView.showsHorizontalReferenceLines = false
        lastNightLineGraphView.showsVerticalReferenceLines = false
        lastNightLineGraphView.axisColor = UIColor.darkGray
        lastNightLineGraphView.verticalAxisTitleColor = UIColor.darkGray
        lastNightLineGraphView.referenceLineColor = UIColor.lightGray
        lastNightLineGraphView.scrubberLineColor = UIColor.blue
        lastNightLineGraphView.scrubberThumbColor = UIColor.green
        
        lightLabel.textColor = UIColor.blue
        humidityLabel.textColor = UIColor.red
        temperatureLabel.textColor = UIColor.purple
        
        lightAverageLabel.textColor = UIColor.blue
        humidityAverageLabel.textColor = UIColor.red
        temperatureAverageLabel.textColor = UIColor.purple
        
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        if let lastNightObj = currentUserData.last{
            let lastNightData = lastNightObj.sensorData
            let tempAvg: Float = lastNightData.average(ofProperty: "sensorTemp")!
            let humidityAvg: Float = lastNightData.average(ofProperty: "sensorHumi")!
            let lightAvg: Float = lastNightData.average(ofProperty: "sensorLight")!
            lightAverageLabel.text = ("Avg.  " + String(describing: tempAvg) + " lux")
            humidityAverageLabel.text = ("Avg.  " + String(describing: humidityAvg) + " %rH")
            temperatureAverageLabel.text = ("Avg.  " + String(describing: lightAvg) + " *C")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {

    
    }

}

