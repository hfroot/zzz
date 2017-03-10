//
//  DatabaseFunctions.swift
//  zzz
//
//  Created by Pierre Azalbert on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import RealmSwift
import ResearchKit

//        try! realm.write {
//            realm.deleteAll()
//            print("DELETED ALL OBJECTS IN REALM");
//        }

func saveSample(sampleTemp:Float,
                sampleHumi:Float,
                sensorTag:String,
                sampleLight:Float,
                sampleAccX:Float,
                sampleAccY:Float,
                sampleAccZ:Float,
                sampleTimestamp:String,
                currentUser:User) {
    
    try! realm.write {
        //let totalACC = sqrt(pow(sampleAccX!,2) + pow(sampleAccY!,2) + pow(sampleAccZ!,2))
        let newData = sensorDataObject(value: ["sensorID": sensorTag,
                                               "sensorTemp": sampleTemp,
                                               "sensorHumi": sampleHumi,
                                               "sensorTimestamp": sampleTimestamp,
                                               "sensorLight":sampleLight,
                                               "sensorAccX": sampleAccX,
                                               "sensorAccY": sampleAccY,
                                               "sensorAccZ": sampleAccZ])
        currentUser.sensorData.append(newData)
        realm.add(currentUser, update: true)
        print("Added sensorData object to database: \(newData)")
    }
}

func registerAccount(registrationData:ORKStepResult) {
    
    let newUser = User()
    
    newUser.email = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.password = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemPassword") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.firstName = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemGivenName") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.lastName = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemFamilyName") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.gender = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemGender") as! ORKQuestionResult) as! ORKChoiceQuestionResult).choiceAnswers![0] as! String
    
    let DoB = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemDOB") as! ORKQuestionResult) as! ORKDateQuestionResult).answer! as! Date
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    newUser.DoB = formatter.string(from: DoB)
    
    try! realm.write {
        realm.add(newUser)
        print("Added User object to database: \(newUser)")
    }

}
