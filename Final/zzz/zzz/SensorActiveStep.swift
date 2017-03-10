//
//  SensorActiveTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 10/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

class SensorStepViewController : ORKActiveStepViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
}

class SensorActiveStep : ORKActiveStep {
    
    static func stepViewControllerClass() -> SensorStepViewController.Type {
        return SensorStepViewController.self
    }
    
}
