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
    
    var allCount:Int = 0
    var sleptWellCount:Int = 0
    var sleptNotWellCount:Int = 0
    var lastUpdate:String = ""
    //var networkWeights = weigthsObject()
    
    @IBOutlet weak var networkLabel: UILabel!
    
    @IBOutlet weak var networkTextLabel: UILabel!
    @IBOutlet weak var networkPieChartView: ORKPieChartView!
    
    let networkPieChartDataSource = AdvicePieChartDataSource()
    
    let networkPieChartIdentifier = "PieChart"
    
    var pieChartDisplay: [CGFloat] = [CGFloat(0.5),
                                      CGFloat(0.3),
                                      CGFloat(0.2),
                                      ]
    
//    @IBOutlet var sleptWellLabel: UILabel?
//    @IBOutlet var sleptNotWellLabel: UILabel?
//    @IBOutlet var lastUpdateLabel: UILabel?
//    @IBOutlet var allCountLabel: UILabel?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getYesterdayStats()
        
        let sleptWellRatio = Float(sleptWellCount)/Float(allCount)*100
        let sleptNotWellRatio = Float(sleptNotWellCount)/Float(allCount)*100
        
//        sleptWellLabel?.text = "\(Int(sleptWellRatio))% of users said they slept well"
//        sleptNotWellLabel?.text = "\(Int(sleptNotWellRatio))% of users said they did not slept well"
//        lastUpdateLabel?.text = "Last update:\(lastUpdate)"
//        allCountLabel?.text = "\(allCount) active users in network"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getYesterdayStats() {
        
        let allUsers = realm.objects(User.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        lastUpdate = formatter.string(from: Date())
        
        allCount = allUsers.count
                
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
