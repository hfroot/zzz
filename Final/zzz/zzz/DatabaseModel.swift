//
//  DatabaseModel.swift
//  zzz
//
//  Created by Pierre Azalbert on 08/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import RealmSwift

import RealmSwift

final class User: Object {
    dynamic var email: String = ""
    dynamic var password: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var gender: String = ""
    dynamic var DoB: String = ""
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    let sleepData = List<sleepDataObject>()
    dynamic var weightsData: weightsDataObject?
}

final class weightsDataObject: Object {
    dynamic var weightHumi: Float = 0.4
    dynamic var weightLight: Float = 0.4
    dynamic var weightCof: Float = 0.4
    dynamic var weightExercise: Float = 0.4
    dynamic var weightSex: Float = 0.4
    dynamic var weightMeal: Float = 0.4
    dynamic var weightAlcohol: Float = 0.4
    dynamic var weightHot: Float = 0.4
    dynamic var weightCold: Float = 0.4
    dynamic var weightDuration: Float = 0.4
    dynamic var weightWater: Float = 0.4
}


final class sensorDataObject: Object {
    dynamic var sensorID: String = ""
    dynamic var Timestamp = Date()
    dynamic var sensorTemp: Float = 0.0
    dynamic var sensorHumi: Float = 0.0
    dynamic var sensorLight: Float = 0.0
    dynamic var sensorAccX: Float = 0.0
    dynamic var sensorAccY: Float = 0.0
    dynamic var sensorAccZ: Float = 0.0
}

final class sleepDataObject: Object {
    dynamic var Timestamp = Date()
    // Before bed survey
    dynamic var beforeBedAnswers: beforeBedAnswersObject?
    // Night monitoring results
    let sensorData = List<sensorDataObject>()
    // After bed survey
    dynamic var afterBedAnswers: afterBedAnswersObject?
}

final class beforeBedAnswersObject: Object {
    let ExerciseQuestion = RealmOptional<Bool>()
    let DinnerQuestion = RealmOptional<Float>()
    let SexQuestion = RealmOptional<Bool>()
    dynamic var StimulantsQuestion: String? = nil
    let NakedQuestion = RealmOptional<Bool>()
    let WaterQuestion = RealmOptional<Bool>()
    let NightDeviceQuestion = RealmOptional<Bool>()
    let NightTiredQuestion = RealmOptional<Bool>()
}

final class afterBedAnswersObject: Object {
    dynamic var WakeLightQuestion: String? = nil
    let ToiletQuestion = RealmOptional<Bool>()
    let NightLightQuestion = RealmOptional<Bool>()
    let WakeDeviceQuestion = RealmOptional<Bool>()
    let WakeTiredQuestion = RealmOptional<Bool>()
    let WakeSleepQuestion = RealmOptional<Bool>()
}

//let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//let realm = try! Realm(configuration: config)

var notificationToken: NotificationToken!
var realm: Realm!

var currentUser = User()
var currentSensorData = List<sensorDataObject>()
