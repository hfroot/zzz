//
//  scheduleViewController.swift
//  zzz
//
//  Created by Helen Root on 27/02/2017.
//  Copyright © 2017 MHML. All rights reserved.
//

import Foundation
import UIKit

//TODO: edit below with necessary fns, weekdays controller has more interesting examples

class ScheduleViewController: UIViewController{
    
    var scheduleDate: Date!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Id.scheduleUnwindIdentifier, sender: self)
    }
}
