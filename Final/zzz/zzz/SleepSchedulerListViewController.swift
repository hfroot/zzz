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
    
    var alarmRow: Int = 0
    var hoursRow: Int = 1
    var bedtimeRow: Int = 2
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
//        self.tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        if indexPath.row == alarmRow {
            cell!.textLabel!.text = "Alarm"
            cell!.detailTextLabel!.text = "7:30 AM"
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == hoursRow {
            cell!.textLabel!.text = "Hours"
            cell!.detailTextLabel!.text = "8.0"
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if indexPath.row == bedtimeRow {
//            bedtimeLabel.text = "11:00 PM"
            let bedtimeCell:InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            print(bedtimeCell)
            bedtimeCell.titleLabel.text = "Bedtime"
            bedtimeCell.valueLabel.text = "11:00 PM"
            bedtimeCell.selectionStyle = .none;
            return bedtimeCell
        }
        return cell!
    }
}
