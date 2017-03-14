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
    var currentAvgBedtime: Date = Date()
    
    init(){}
    
    func determineSleepHours() {
        // eventually pull data from db to get ideal hours
        sleepHours = 8.0
    }
    
    func calculateBedtime() {
        bedtime = waketime - sleepHours*60*60
    }
    
    func formatTimes() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        formattedBedtime = dateFormatter.string(from: self.bedtime)
        formattedAlarm = dateFormatter.string(from: self.waketime)
    }
    
    func calculateCurrentAvgBedtime() {
//        let today = Date()
        let days = 7
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        print("User data:")
        print(currentUserData.count)
        var bedtime = [Date]()
        for i in 1...days {
            let idx = currentUserData.count - i
            if (idx >= 0) {
                bedtime.append(currentUserData[idx].Timestamp)
            }
        }
        var totalMins = 0
        var avgMins = 0
        for i in 0...bedtime.count-1 {
            let bt = bedtime[i]
            let hour = Calendar.current.component(.hour, from: bt)
            let minute = Calendar.current.component(.minute, from: bt)
            totalMins += minute + hour*60
        }
        avgMins = totalMins/bedtime.count
        let minutes = avgMins%60
        let hours = (avgMins - minutes)/60
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        currentAvgBedtime = dateFormatter.date(from: "\(hours):\(minutes)")!
        print("Cur Bedtime:")
        print(currentAvgBedtime)
    }
}
