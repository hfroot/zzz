//
//  User.swift
//  ZZZ
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
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
    dynamic var sensorTimestamp = ""
    dynamic var sensorTemp: Float = 0.0
    dynamic var sensorHumi: Float = 0.0
    //dynamic var sensorLight: Double = 0.0
    //dynamic var sensorNoise: Double = 0.0
    //dynamic var sensorAccel: Double = 0.0
    
    //    override static func primaryKey() -> String? {
    //        return "sensorTimestamp"
    //    }
}
