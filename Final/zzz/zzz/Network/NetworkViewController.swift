//
//  ViewController.swift
//  zzz
//
//  Created by Pierre Azalbert on 14/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import UIKit
import RealmSwift
import ResearchKit

class NetworkViewController: UIViewController {
    
    var networkCount:Int = 0
    var sleptWellCount:Int = 0
    var sleptNotWellCount:Int = 0
    var lastUpdate:String = ""
    
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var networkPieChart1: ORKPieChartView!

    
    let network1PieChartDataSource = Network1PieChartDataSource()
    
    let networkPieChartIdentifier = "PieChart"
    
    var pieChartDisplay: [CGFloat] = []

    @IBOutlet var lastUpdateLabel: UILabel?
    @IBOutlet var allCountLabel: UILabel?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getYesterdayStats()
        
        let sleptWellRatio = Float(sleptWellCount)/Float(networkCount)*100
        let sleptNotWellRatio = Float(sleptNotWellCount)/Float(networkCount)*100
        let unknown = 100 - sleptWellRatio - sleptNotWellRatio
        
        pieChartDisplay = [CGFloat(sleptWellRatio),
                            CGFloat(sleptNotWellRatio),
                            CGFloat(unknown)]
        
        updateNetwork1PieChartValues(newValues: pieChartDisplay)
        
        networkPieChart1?.dataSource = network1PieChartDataSource
        networkPieChart1?.lineWidth = 12
        networkPieChart1?.drawsClockwise = true
        networkPieChart1?.showsPercentageLabels = true
        networkPieChart1?.tintColor = UIColor.purple
        
        lastUpdateLabel?.text = "Last update:\(lastUpdate)"
        allCountLabel?.text = "\(networkCount) active users in network"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getYesterdayStats() {
        
        let allUsers = realm.objects(User.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        lastUpdate = formatter.string(from: Date())
        
        networkCount = allUsers.count
                
        for user in allUsers {
            let yesterdayData = user.sleepData.last
            if let sleptWell = yesterdayData?.afterBedAnswers?.WakeSleepQuestion.value {
                if sleptWell == true {
                    sleptWellCount += 1
                }
                else {
                    sleptNotWellCount += 1
                }
            }
            
        }
        
        
    }

}
