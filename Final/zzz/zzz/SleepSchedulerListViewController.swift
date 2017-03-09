//
//  SleepSchedulerListViewController.swift
//  zzz
//
//  Created by Helen Root on 09/03/2017.
//  Copyright © 2017 Helen Root. All rights reserved.
//

import Foundation
import UIKit

class SleepSchedulerListViewController: UITableViewController {
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
//    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
//        tableView.dataSource = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: Id.settingIdentifier)
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Id.settingIdentifier)
        }
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                cell!.textLabel!.text = "Alarm"
                cell!.detailTextLabel!.text = "7:30 AM" //repeatText // edit
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 1 {
                cell!.textLabel!.text = "Sleep hours"
                cell!.detailTextLabel!.text = "8.0"// segueInfo.label // edit
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 2 {
                cell!.textLabel!.text = "Bedtime"
                cell!.detailTextLabel!.text = "11:30 PM"//segueInfo.mediaLabel // edit
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        else if indexPath.section == 1 {
//            cell = UITableViewCell(
//                style: UITableViewCellStyle.default, reuseIdentifier: Id.settingIdentifier)
            cell!.textLabel!.text = "Delete Schedule"
            cell!.textLabel!.textAlignment = .center
            cell!.textLabel!.textColor = UIColor.red
        }
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
//                performSegue(withIdentifier: Id.alarmPickerSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
//            case 1:
//                performSegue(withIdentifier: Id.labelSegueIdentifier, sender: self)
//                cell?.setSelected(true, animated: false)
//                cell?.setSelected(false, animated: false)
//            case 2:
//                performSegue(withIdentifier: Id.soundSegueIdentifier, sender: self)
//                cell?.setSelected(true, animated: false)
//                cell?.setSelected(false, animated: false)
            default:
                break
            }
        }
        else if indexPath.section == 1 {
            //delete alarm
//            alarmModel.alarms.remove(at: segueInfo.curCellIndex)
//            alarmScheduler.reSchedule()
//            performSegue(withIdentifier: Id.saveSegueIdentifier, sender: self)
        }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }    
}
