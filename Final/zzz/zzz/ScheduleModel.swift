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
    var currentAvgBedtime: Date!
    var formattedCurAvgBT: String = ""
    var increment: Int = 15 // default
    var currentAimBedtime: Date!
    var formattedCurAimBT: String = ""
    var direction: String = ""
    var reqNumberOfDays: Int!
    
    init(){}
    
    func determineSleepHours() {
        // eventually pull data from db to get ideal hours
        sleepHours = 8.0
    }
    
    func calculateBedtime() {
        bedtime = waketime - sleepHours*60*60
        if (currentAvgBedtime != nil) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: bedtime)
            let aimBedtimeHour = calendar.component(.hour, from: bedtime)
            var curBedtimeHour = calendar.component(.hour, from: currentAvgBedtime)
            let aimBedtimeMin = calendar.component(.minute, from: bedtime)
            var curBedtimeMin = calendar.component(.minute, from: currentAvgBedtime)
            var difference = 0
            if (abs(aimBedtimeHour-curBedtimeHour) < 12) {
                // eg moving between 9 PM and 11 PM
                if (curBedtimeHour < aimBedtimeHour) {
                    // 9 PM to 11 PM
                    print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- moving forward")
                    direction = "forward"
                } else {
                    // 11 PM to 9 PM
                    print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- moving backward")
                    direction = "backward"
                }
                difference = abs(aimBedtimeHour-curBedtimeHour)*60 + abs(aimBedtimeMin-curBedtimeMin)
            } else {
                // eg moving between 1 AM and 11 PM
                if (curBedtimeHour < aimBedtimeHour) {
                    // 1 AM to 11 PM
                    print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- moving backward")
                    direction = "backward"
                    difference = (curBedtimeHour + 24-aimBedtimeHour)*60 + (curBedtimeMin + 60-aimBedtimeHour)
                } else {
                    // 11 PM to 1 AM
                    print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- moving forward")
                    direction = "forward"
                    difference = (aimBedtimeHour + 24-curBedtimeHour)*60 + (aimBedtimeMin + 60-curBedtimeHour)
                }
            }
            reqNumberOfDays = difference/increment
            print("It will take you \(reqNumberOfDays) days to achieve your goal")
            if (direction == "forward") {
                if (curBedtimeMin+increment < 60) {
                    curBedtimeMin += increment
                } else {
                    curBedtimeMin = curBedtimeMin + increment - 60
                    curBedtimeHour += 1
                }
            }
            
            currentAimBedtime = calendar.date(from: components)!
        }
        
    }
    
    func formatTimes() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        formattedBedtime = dateFormatter.string(from: self.bedtime)
        formattedAlarm = dateFormatter.string(from: self.waketime)
        if ((currentAvgBedtime) != nil) {
            formattedCurAvgBT = dateFormatter.string(from: self.currentAvgBedtime)
        }
        if ((currentAimBedtime) != nil) {
            formattedCurAimBT = dateFormatter.string(from: self.currentAimBedtime)
        }
    }
    
    func calculateCurrentAvgBedtime() {
        let days = 7
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        var bedtime = [Date]()
        for i in 1...days {
            let idx = currentUserData.count - i
            if (idx >= 0) {
                bedtime.append((currentUserData[idx].sensorData.first?.Timestamp)!)
            }
        }
        print("Bedtime:")
        print(bedtime)
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
    }
    
    func calculateCurrentTimes() {
        let today = Date()
        let calendar = Calendar.current
        let aimDay = calendar.ordinality(of: .day, in: .year, for: currentAimBedtime)
        let todayDay = calendar.ordinality(of: .day, in: .year, for: today)
        if (todayDay! > aimDay!) {
            // update current bedtime aim
            print("days between aim and today: \(todayDay!-aimDay!)")
        }
    }
}
