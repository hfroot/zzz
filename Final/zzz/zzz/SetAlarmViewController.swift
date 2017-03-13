//
//  SetAlarmViewController.swift
//  zzz
//
//  Created by Helen Root on 12/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import UIKit

class SetAlarmViewController: UIViewController {
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    var schedule: Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmPicker.date = schedule.waketime
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Id.setAlarmSegueUnwindIdentifier, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        schedule.waketime = alarmPicker.date
        let dest = segue.destination as! SleepSchedulerListViewController
        dest.schedule = schedule
    }
}
