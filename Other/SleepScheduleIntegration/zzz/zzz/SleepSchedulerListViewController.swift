//
//  SleepSchedulerListViewController.swift
//  zzz
//
//  Created by Helen Root on 09/03/2017.
//  Copyright © 2017 Helen Root. All rights reserved.
//

import Foundation
import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SleepSchedulerListViewController: UITableViewController {
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
 
    var schedule: Schedule!
    var alarmRow: Int = 0
    var hoursRow: Int = 1
    var bedtimeRow: Int = 2
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ScheduleCell")
        }
        if (schedule != nil) {
            schedule.calculateBedtime()
            schedule.formatTimes()
        } else {
            schedule = Schedule()
            schedule.calculateBedtime()
            schedule.formatTimes()
            schedule.calculateCurrentAvgBedtime()
        }
        if indexPath.row == alarmRow {
            cell!.textLabel!.text = "Alarm"
            cell!.detailTextLabel!.text = schedule.formattedAlarm
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == hoursRow {
            cell!.textLabel!.text = "Hours"
            cell!.detailTextLabel!.text = String(format: "%.1f", schedule.sleepHours)
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == bedtimeRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Bedtime"
            bedtimeCell.valueLabel.text = schedule.formattedBedtime
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == alarmRow {
            // trigger alarm setting segue
            performSegue(withIdentifier: "editAlarmSegue", sender: nil)
        }
        else if indexPath.row == hoursRow {
            // trigger hours setting segue
            performSegue(withIdentifier: "editHoursSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Id.editAlarmSegueIdentifier {
            let dest = segue.destination as! SetAlarmViewController
            dest.schedule = schedule
        }
        else if segue.identifier == Id.setHoursSegueIdentifier {
            let dest = segue.destination as! SleepHoursViewController
            dest.hours = schedule.sleepHours
        }
    }
    
    @IBAction func unwindFromSetAlarmView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! SetAlarmViewController
        schedule = src.schedule
    }
    
    @IBAction func unwindFromSetHoursView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! SleepHoursViewController
        schedule.sleepHours = src.hours
    }
    
}
