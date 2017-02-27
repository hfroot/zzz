//
//  Copyright Helen Root © 2017 MHML. All rights reserved.
//
//  WeekdaysViewController.swift
//  Alarm-ios-swift
//
//  Created by longyutao on 15/10/15.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class WeekdaysViewController: UITableViewController {
    
    //TODO: the repeating days don't seem to be saved when go on to edit alarm
    var weekdays: [Int]!
    var repeatText: String
    {
        if weekdays.count == 7 {
            return "Every day"
        }
        
        if weekdays.isEmpty {
            return "Never"
        }
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = weekdays.sorted(by: <)
        var allWeekdays = true
        var allWeekends = true
        
        for day in weekdaysSorted {
            switch day{
            case 1:
                ret += "Sun "
                allWeekdays = false
            case 2:
                ret += "Mon "
                allWeekends = false
            case 3:
                ret += "Tue "
                allWeekends = false
            case 4:
                ret += "Wed "
                allWeekends = false
            case 5:
                ret += "Thu "
                allWeekends = false
            case 6:
                ret += "Fri "
                allWeekends = false
            case 7:
                ret += "Sat "
                allWeekdays = false
            default:
                //throw
                break
            }
        }
        if allWeekends {
            return "Weekends"
        }
        else if allWeekdays {
            return "Weekdays"
        }
        
        return ret
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Id.weekdaysUnwindIdentifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        for weekday in weekdays
        {
            if weekday == (indexPath.row + 1) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let index = weekdays.index(of: (indexPath.row + 1)){
            weekdays.remove(at: index)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            //row index start from 0, weekdays index start from 1 (Sunday), so plus 1
            weekdays.append(indexPath.row + 1)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
    }
}
