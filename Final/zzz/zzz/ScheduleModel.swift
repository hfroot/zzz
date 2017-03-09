//
//  ScheduleModel.swift
//  zzz
//
//  Created by Helen Root on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation

class Schedule {
    var waketime: Date = Date()
    var formattedAlarm: String = ""
    var bedtime: Date = Date()
    var formattedBedtime: String = ""
    var sleepHours: Double = 8.0 // default
    
    
    init(){}
    
    func determineSleepHours() {
        // eventually pull data from db to get ideal hours
        sleepHours = 8.0
    }
    
    func determineBedtime() {
        bedtime = waketime - sleepHours
    }
    
    func formatTimes() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        formattedBedtime = dateFormatter.string(from: self.bedtime)
        formattedAlarm = dateFormatter.string(from: self.waketime)
    }
}
