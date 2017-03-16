//
//  ViewController.swift
//  zzz
//
//  Created by user125883 on 3/9/17.
//  Copyright © 2017 Julia Booth. All rights reserved.
//

import UIKit
import ResearchKit

class AdviceViewController: UIViewController {
    
    
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBOutlet weak var adviceTextLabel: UILabel!
    @IBOutlet weak var advicePieChartView: ORKPieChartView!
    
    let advicePieChartDataSource = AdvicePieChartDataSource()
    
    let advicePieChartIdentifier = "PieChart"
    
    let recommend = RecommendationEngine()
    
    var pieChartDisplay: [CGFloat] = [CGFloat(0.6),
                                      CGFloat(0.6),
                                      CGFloat(0.5),
                                      CGFloat(0.3),
                                      CGFloat(0.4),
                                      CGFloat(0.4),
                                      CGFloat(0.3),
                                      CGFloat(0.6),
                                      CGFloat(0.6)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].weightsData
        recommend.factorWeights["duration"] = currentUserData?.weightDuration
        recommend.factorWeights["exercise"] = currentUserData?.weightExercise
        recommend.factorWeights["caffeine"] = currentUserData?.weightCof
        recommend.factorWeights["meal"] = currentUserData?.weightMeal
        recommend.factorWeights["alcohol"] = currentUserData?.weightAlcohol
        recommend.factorWeights["light"] = currentUserData?.weightLight
        recommend.factorWeights["heat"] = currentUserData?.weightHot
        recommend.factorWeights["cold"] = currentUserData?.weightCold
        recommend.factorWeights["humidity"] = currentUserData?.weightHumi
        
            
        pieChartDisplay[0] = CGFloat(recommend.factorWeights["duration"]!)
        pieChartDisplay[1] = CGFloat(recommend.factorWeights["exercise"]!)
        pieChartDisplay[2] = CGFloat(recommend.factorWeights["caffeine"]!)
        pieChartDisplay[3] = CGFloat(recommend.factorWeights["meal"]!)
        pieChartDisplay[4] = CGFloat(recommend.factorWeights["alcohol"]!)
        pieChartDisplay[5] = CGFloat(recommend.factorWeights["light"]!)
        pieChartDisplay[6] = CGFloat(recommend.factorWeights["heat"]!)
        pieChartDisplay[7] = CGFloat(recommend.factorWeights["cold"]!)
        pieChartDisplay[8] = CGFloat(recommend.factorWeights["humidity"]!)
        
        let suggest: String = recommend.getAdvice()
        adviceTextLabel.text = suggest
        
        updatePieChartValues(newValues: pieChartDisplay)
 
        
        advicePieChartView?.dataSource = advicePieChartDataSource
        
        advicePieChartView?.lineWidth = 12
        advicePieChartView?.drawsClockwise = true
        advicePieChartView?.showsPercentageLabels = true
        advicePieChartView?.tintColor = UIColor.purple
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {

    
    }

}

