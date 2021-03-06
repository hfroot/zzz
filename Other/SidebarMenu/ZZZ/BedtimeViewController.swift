//
//  BedtimeViewController.swift
//  ZZZ
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ResearchKit

class BedtimeViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let step0 = ORKInstructionStep(identifier: "intro")
        step0.title = "Time to go to bed"
        
        let step1 = ORK
        step1.title = ""
        
        let task = ORKOrderedTask(identifier: "bedtime", steps: [step0, step1])
        
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController,
                            didFinishWith reason: ORKTaskViewControllerFinishReason,
                            error: Error?) {
        let taskResult = taskViewController.result
        // You could do something with the result here.
        print(taskResult)
        
        // Then, dismiss the task view controller.
        dismiss(animated: true, completion: nil)
    }
    
}
