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
    var formattedTimes = Dictionary<String, String>()
    var alarmRow: Int = 0
    var hoursRow: Int = 1
    var bedtimeRow: Int = 2
    var suggestionRow: Int = 3
    var incrementRow: Int = 4
    var curBedtimeRow: Int = 5
    var daysRow: Int = 6
    var msgRow: Int = 7
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (schedule != nil) {
            schedule.calculateBedtime()
            formattedTimes = schedule.formatTimes()
        } else {
            schedule = Schedule()
            schedule.calculateBedtime()
            formattedTimes = schedule.formatTimes()
            schedule.calculateCurrentAvgBedtime()
        }
        tableView.reloadData()
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ScheduleCell")
        }
        if indexPath.row == alarmRow {
            cell!.textLabel!.text = "Goal Waketime"
            cell!.detailTextLabel!.text = formattedTimes["alarm"]
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == hoursRow {
            cell!.textLabel!.text = "Hours"
            cell!.detailTextLabel!.text = String(format: "%.1f", schedule.sleepHours)
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == bedtimeRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Goal Bedtime"
            bedtimeCell.valueLabel.text = formattedTimes["bedtime"]
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        else if indexPath.row == suggestionRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Current avg bedtime"
            bedtimeCell.valueLabel.text = formattedTimes["currentAvgBT"]
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        else if indexPath.row == incrementRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Increment"
            bedtimeCell.valueLabel.text = "\(schedule.increment) mins"
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        else if indexPath.row == curBedtimeRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Today's bedtime"
            bedtimeCell.valueLabel.text = formattedTimes["currentAimBT"]
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        else if indexPath.row == daysRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = "Days to goal"
            if (schedule.reqNumberOfDays != nil) {
                bedtimeCell.valueLabel.text = "\(schedule.reqNumberOfDays!)"
            } else {
                bedtimeCell.valueLabel.text = ""
            }
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        else if indexPath.row == msgRow {
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            bedtimeCell.titleLabel.text = schedule.onTrackMsg
            bedtimeCell.valueLabel.text = ""
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
        else if segue.identifier == "saveScheduleEdit" {
            schedule.saveToRealm()
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
