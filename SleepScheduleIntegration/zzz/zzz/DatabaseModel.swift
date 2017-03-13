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
    
    let sensorData = List<sensorDataObject>()
}

final class sensorDataObject: Object {
    dynamic var sensorID: String = ""
    dynamic var sensorTimestamp = Date()
    dynamic var sensorTemp: Float = 0.0
    dynamic var sensorHumi: Float = 0.0
    dynamic var sensorLight: Float = 0.0
    //dynamic var sensorNoise: Double = 0.0
    dynamic var sensorAccX: Float = 0.0
    dynamic var sensorAccY: Float = 0.0
    dynamic var sensorAccZ: Float = 0.0
    
//    override static func primaryKey() -> String? {
//        return "sensorTimestamp"
//    }
}

final class surveyDataObject: Object {
    dynamic var surveyTimestamp = Date()
    // Before bed survey
    dynamic var ExerciseQuestionStep: String = ""
    dynamic var DinnerQuestionStep: String = ""
    dynamic var SexQuestionStep: String = ""
    dynamic var StimulantsQuestionStep: String = ""
    dynamic var NakedQuestionStep: String = ""
    dynamic var WaterQuestionStep: String = ""
    dynamic var NightDeviceQuestionStep: String = ""
    dynamic var NightTiredQuestionStep: String = ""
    // After bed survey
    dynamic var WakeLightQuestionStep: String = ""
    dynamic var ToiletQuestionStep: String = ""
    dynamic var NightLightQuestionStep: String = ""
    dynamic var WakeDeviceQuestionStep: String = ""
    dynamic var WakeTiredQuestionStep: String = ""
    dynamic var WakeSleepQuestionStep: String = ""
}

let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
let realm = try! Realm(configuration: config)

var currentUser = User()
