//
//  ViewController.swift
//  zzz
//
//  Created by user125883 on 3/9/17.
//  Copyright © 2017 Julia Booth. All rights reserved.
//

import UIKit
import ResearchKit

class AdviceViewController: UIViewController{//, UITableViewDataSource {
    
    let recommend = RecommendationEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommend.factorWeights["duration"] = 0.7
        let suggest: String = recommend.getAdvice()
        print(suggest)
        //durationLabel.text = String(0.4)
        //durationLabel.text = String(describing: recommend.factorWeights["duration"])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recommend.factorWeights["light"] = 0.8
        let advice: String = recommend.getAdvice()
        print(advice)
    }

}

