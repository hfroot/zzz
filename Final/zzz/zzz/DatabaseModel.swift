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
    dynamic var id = 0
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let sensorData = List<sensorDataObject>()
}

final class sensorDataObject: Object {
    dynamic var sensorID = ""
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

//let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
let realm = try! Realm(/*configuration: config*/)
