//
//  SensorActiveTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 10/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//


import UIKit
import ResearchKit
import RealmSwift

class SensorStepViewController : ORKActiveStepViewController {

//    var lastTimestamp:Date? = Date()
//    var sensorData = List<sensorDataObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CGRectMake has been deprecated - and should be let, not var
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        
//        // you will probably want to set the font (remember to use Dynamic Type!)
//        label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        
//        // and set the text color too - remember good contrast
//        label.textColor = .black
        
        // may not be necessary (e.g., if the width & height match the superview)
        // if you do need to center, CGPointMake has been deprecated, so use this
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y
        
        // this changed in Swift 3 (much better, no?)
        label.textAlignment = .center
        
        label.text = "I am a test label"
        
        self.view.addSubview(label)
        
//        let demoView = SensorViewController()
//        demoView.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
//        demoView.translatesAutoresizingMaskIntoConstraints = false
//        self.customView = demoView
//        self.customView?.superview!.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[demoView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["demoView": demoView]))
    }
    
}

class SensorActiveStep : ORKActiveStep {
    
//    static func stepViewControllerClass() -> SensorStepViewController.Type {
//        return SensorStepViewController.self
//    }
    
    static func stepViewControllerClass() -> SensorStepViewController.Type {
        return SensorStepViewController.self
    }
    
}
