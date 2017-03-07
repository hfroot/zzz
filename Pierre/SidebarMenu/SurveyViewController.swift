//
//  SurveyViewController.swift
//  SidebarMenu
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ResearchKit

class SurveyViewController: UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let myStep = ORKInstructionStep
        
    }
    
}
