//
//  ScheduleModel.swift
//  zzz
//
//  Created by Helen Root on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation

class Schedule {
    var waketime: Date!
    var bedtime: Date!
    var sleepHours: Double = 8.0 // default
    var currentAvgBedtime: Date!
    var increment: Int = 15 // default
    var currentAimBedtime: Date!
    var direction: String = ""
    var reqNumberOfDays: Int!
    
    init(){}
    
    func determineSleepHours() {
        // eventually pull data from db to get ideal hours
        sleepHours = 8.0
    }
    
    func calculateBedtime() {
        if (waketime != nil) {
            bedtime = waketime - sleepHours*60*60
            if (currentAvgBedtime != nil) {
                let calendar = Calendar.current
                let aimBedtimeHour = calendar.component(.hour, from: bedtime)
                let curBedtimeHour = calendar.component(.hour, from: currentAvgBedtime)
                let aimBedtimeMin = calendar.component(.minute, from: bedtime)
                let curBedtimeMin = calendar.component(.minute, from: currentAvgBedtime)
                var difference = 0
                if (abs(aimBedtimeHour-curBedtimeHour) < 12) {
                    // eg moving between 9 PM and 11 PM
                    difference = abs(aimBedtimeHour-curBedtimeHour)*60 + abs(aimBedtimeMin-curBedtimeMin)
                    if (curBedtimeHour < aimBedtimeHour) {
                        // 9 PM to 11 PM
                        print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- there are \(difference) minutes between times")
                        direction = "forward"
                    } else {
                        // 11 PM to 9 PM
                        print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- there are \(difference) minutes between times")
                        direction = "backward"
                    }
                } else {
                    // eg moving between 1 AM and 11 PM
                    if (curBedtimeHour < aimBedtimeHour) {
                        // 1 AM to 11 PM
                        difference = (curBedtimeHour + 24-aimBedtimeHour)*60 + (curBedtimeMin + 60-aimBedtimeHour)
                        print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- there are \(difference) minutes between times")
                        direction = "backward"
                    } else {
                        // 11 PM to 1 AM
                        difference = (aimBedtimeHour + 24-curBedtimeHour)*60 + (aimBedtimeMin + 60-curBedtimeHour)
                        print("Aim hour: \(aimBedtimeHour), cur hour: \(curBedtimeHour) -- there are \(difference) minutes between times")
                        direction = "forward"
                    }
                }
                reqNumberOfDays = difference/increment
                print("It will take you \(reqNumberOfDays!) days to achieve your goal")
                
                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentAvgBedtime)
                if (direction == "forward") {
                    if (components.minute!+increment < 60) {
                        components.minute! += increment
                    } else {
                        components.minute! = components.minute! + increment - 60
                        components.hour! += 1
                    }
                }
                
                currentAimBedtime = calendar.date(from: components)!
            }
        }
        
    }
    
    func formatTimes() -> Dictionary<String, String> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        var formattedDates = Dictionary<String, String>()
        if (bedtime != nil) {
            formattedDates["bedtime"] = dateFormatter.string(from: self.bedtime)
        }
        if (waketime != nil) {
            formattedDates["alarm"] = dateFormatter.string(from: self.waketime)
        }
        if ((currentAvgBedtime) != nil) {
            formattedDates["currentAvgBT"] = dateFormatter.string(from: self.currentAvgBedtime)
        }
        if ((currentAimBedtime) != nil) {
            formattedDates["currentAimBT"] = dateFormatter.string(from: self.currentAimBedtime)
        }
        return formattedDates
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
