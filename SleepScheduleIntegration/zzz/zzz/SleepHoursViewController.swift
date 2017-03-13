//
//  SleepHoursViewController.swift
//  zzz
//
//  Created by Helen Root on 13/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import UIKit

class SleepHoursViewController: UIViewController {
    
    @IBOutlet weak var hoursSlider: UISlider!
    @IBOutlet weak var hoursLabel: UILabel!
    var hours: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursSlider.value = Float(hours)
        hoursLabel.text = String(format: "%.1f", hours)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Id.setHoursSegueUnwindIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SleepSchedulerListViewController
        dest.schedule.sleepHours = hours
    }
    
    @IBAction func updateHours(_ sender: UISlider) {
        let step: Float = 0.5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        let currentValue = sender.value
        hoursLabel.text = String(format: "%.1f", currentValue)
        hours = Double(currentValue)
    }
}
