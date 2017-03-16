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
    var increment: Int = 15 // default
    var currentAimBedtime: Date!
    // below not in DB
    var currentAvgBedtime: Date!
    var direction: String = ""
    var reqNumberOfDays: Int!
    var onTrackMsg: String!
    
    init() {
        let currentUserScheduleData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].scheduleData
        self.waketime = currentUserScheduleData?.Waketime
        self.bedtime = currentUserScheduleData?.GoalBedtime
        self.sleepHours = Double((currentUserScheduleData?.SleepHours)!)
        self.increment = (currentUserScheduleData?.Increment)!
    }
    
    func getTimeDifference(aimMin: Int, aimHour: Int, curMin: Int, curHour: Int) -> Int {
        var difference = 0
        if (abs(aimHour-curHour) < 12) {
            // eg moving between 9 PM and 11 PM
            difference = (aimHour-curHour)*60 + aimMin-curMin
            if (curHour < aimHour) {
                // 9 PM to 11 PM
                print("9 to 11")
                direction = "forward"
            } else {
                // 11 PM to 9 PM
                print("11 to 9")
                direction = "backward"
            }
        } else {
            // eg moving between 1 AM and 11 PM
            if (curHour < aimHour) {
                // 1 AM to 11 PM
                print("1 to 11")
                difference = (curHour + 24-aimHour)*60 + (curMin + 60-aimMin)
                direction = "backward"
            } else {
                // 11 PM to 1 AM
                print("11 to 1")
                difference = -((aimHour + 24-curHour)*60 + (aimMin + 60-curMin))
                direction = "forward"
            }
        }
        print("Aim hour: \(aimHour), cur hour: \(curHour) -- there are \(difference) minutes between times")
        return difference
    }
    
    func calculateBedtime() {
        if (waketime != nil) {
            bedtime = waketime - sleepHours*60*60
            self.calculateCurrentAvgBedtime()
            if (currentAvgBedtime != nil) {
                let calendar = Calendar.current
                let aimBedtimeHour = calendar.component(.hour, from: bedtime)
                let curBedtimeHour = calendar.component(.hour, from: currentAvgBedtime)
                let aimBedtimeMin = calendar.component(.minute, from: bedtime)
                let curBedtimeMin = calendar.component(.minute, from: currentAvgBedtime)
                var difference = 0
                difference = getTimeDifference(aimMin: aimBedtimeMin, aimHour: aimBedtimeHour, curMin: curBedtimeMin, curHour: curBedtimeHour)
                reqNumberOfDays = abs(difference)/increment
                print("It will take you \(reqNumberOfDays!) days to achieve your goal")
                
                // determine if on track, behind or ahead
                var onTrack = ""
                if (difference > 15) {
                    if (direction == "forward") {
                        onTrack = "ahead"
                    } else if (direction == "backward") {
                        onTrack = "behind"
                    }
                } else if (difference < -15) {
                    if (direction == "forward") {
                        onTrack = "behind"
                    } else if (direction == "backward") {
                        onTrack = "ahead"
                    }
                } else {
                    onTrack = "onTrack"
                }
                if (currentAimBedtime == nil) {
                    currentAimBedtime = currentAvgBedtime
                }
                let secondsInc = TimeInterval(increment*60)
                if (onTrack == "onTrack") {
//                    if (direction == "forward") {
//                        currentAimBedtime = currentAimBedtime + secondsInc
//                    } else {
//                        currentAimBedtime = currentAimBedtime - secondsInc
//                    }
                    onTrackMsg = "Well done, you're on track!"
                } else if (onTrack == "ahead") {
                    if (direction == "forward") {
                        currentAimBedtime = currentAvgBedtime + secondsInc
                    } else {
                        currentAimBedtime = currentAvgBedtime - secondsInc
                    }
                    onTrackMsg = "Well done, you're ahead!"
                } else if (onTrack == "behind") {
                    if (direction == "forward") {
                        currentAimBedtime = currentAvgBedtime + secondsInc
                    } else {
                        currentAimBedtime = currentAvgBedtime - secondsInc
                    }
                    onTrackMsg = "Watch out, you're falling behind!"
                }
                self.saveToRealm()
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
        // ideally drop off
        let days = 7
        let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData
        if (currentUserData.count <= 0) {
            return
        }
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
    
    func saveToRealm() {
        let newScheduleData = scheduleObject(value: ["Waketime": waketime,
                                                     "GoalBedtime": bedtime,
                                                     "SleepHours": sleepHours,
                                                     "Increment": increment
                                                ])
        if (currentAimBedtime != nil) {
            newScheduleData["CurrentIdealBedtime"] = currentAimBedtime
        }
        saveScheduleData(newScheduleData: newScheduleData)
    }
}
