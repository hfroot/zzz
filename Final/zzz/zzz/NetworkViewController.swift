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
    var networkWeights : weightsDataObject?
    
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var networkPieChart1: ORKPieChartView!
    @IBOutlet weak var networkPieChart2: ORKPieChartView!

    
    let networkPieChartDataSource = NetworkPieChartDataSource()
    
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
        
        updateNetworkPieChartValues(newValues: pieChartDisplay)
        
        networkPieChart1?.dataSource = networkPieChartDataSource
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
        
        networkWeights?.weightHumi = allUsers.average(ofProperty: "weightsData.weightHumi")!
        networkWeights?.weightCof = allUsers.average(ofProperty: "weightsData.weightCof")!
        networkWeights?.weightHot = allUsers.average(ofProperty: "weightsData.weightHot")!
        networkWeights?.weightSex = allUsers.average(ofProperty: "weightsData.weightSex")!
        networkWeights?.weightCold = allUsers.average(ofProperty: "weightsData.weightCold")!
        networkWeights?.weightMeal = allUsers.average(ofProperty: "weightsData.weightMeal")!
        networkWeights?.weightLight = allUsers.average(ofProperty: "weightsData.weightLight")!
        networkWeights?.weightWater = allUsers.average(ofProperty: "weightsData.weightWater")!
        networkWeights?.weightAlcohol = allUsers.average(ofProperty: "weightsData.weightAlcohol")!
        networkWeights?.weightDuration = allUsers.average(ofProperty: "weightsData.weightDuration")!
        networkWeights?.weightExercise = allUsers.average(ofProperty: "weightsData.weightExercise")!
        
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
