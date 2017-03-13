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
                                      CGFloat(0.6),
                                      CGFloat(0.5),
                                      CGFloat(0.5),
                                      CGFloat(0.3),
                                      CGFloat(0.5)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommend.factorWeights["duration"] = 0.7
        let suggest: String = recommend.getAdvice()
        print(suggest)
        adviceTextLabel.text = suggest
        
        pieChartDisplay[0] = CGFloat(recommend.factorWeights["duration"]!)
        pieChartDisplay[1] = CGFloat(recommend.factorWeights["exercise"]!)
        pieChartDisplay[2] = CGFloat(recommend.factorWeights["caffeine"]!)
        pieChartDisplay[3] = CGFloat(recommend.factorWeights["meal"]!)
        pieChartDisplay[4] = CGFloat(recommend.factorWeights["nicotine"]!)
        pieChartDisplay[5] = CGFloat(recommend.factorWeights["alcohol"]!)
        pieChartDisplay[6] = CGFloat(recommend.factorWeights["relaxation"]!)
        pieChartDisplay[7] = CGFloat(recommend.factorWeights["light"]!)
        pieChartDisplay[8] = CGFloat(recommend.factorWeights["noise"]!)
        pieChartDisplay[9] = CGFloat(recommend.factorWeights["heat"]!)
        pieChartDisplay[10] = CGFloat(recommend.factorWeights["cold"]!)
        pieChartDisplay[11] = CGFloat(recommend.factorWeights["humidity"]!)
        pieChartDisplay[12] = CGFloat(recommend.factorWeights["device"]!)
        
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

