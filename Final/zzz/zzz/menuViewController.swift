//
//  menuViewController.swift
//  zzz
//
//  Created by Pierre Azalbert on 10/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import UIKit
import ResearchKit

class menuViewController: UIViewController {
    
    @IBAction func beforeBedSurveyTapped(sender : AnyObject) {
        let beforeBedTaskViewController = ORKTaskViewController(task: BeforeBedSurveyTask, taskRun: nil)
        beforeBedTaskViewController.delegate = self
        present(beforeBedTaskViewController, animated: true, completion: nil)
    }

    @IBAction func afterBedSurveyTapped(sender : AnyObject) {
        let afterBedTaskViewController = ORKTaskViewController(task: AfterBedSurveyTask, taskRun: nil)
        afterBedTaskViewController.delegate = self
        present(afterBedTaskViewController, animated: true, completion: nil)
    }

    @IBAction func chartsTapped(sender : AnyObject) {
        present(ChartListViewController(), animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension menuViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed: break
            
           // if let surveyData = taskViewController.result.stepResult(forStepIdentifier: "RegisterStep") {

        case .failed, .discarded, .saved: break
        }
    }
}
        
