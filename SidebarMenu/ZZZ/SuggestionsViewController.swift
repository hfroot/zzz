//
//  ProgrammaticalDemo.swift
//  PieCharts
//  https://github.com/i-schuetz/PieCharts
//
//  Created by Hyun Min Choi on 2017. 1. 23..
//  Copyright © 2017년 Ivan Schuetz. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
}
