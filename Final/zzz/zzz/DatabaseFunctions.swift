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

func saveSleepData(newSleepData:sleepDataObject) {
    
    try! realm.write {
        currentUser.sleepData.append(newSleepData)
        realm.add(currentUser, update: true)
        print("Added sleepData object to database: \(newSleepData)")
    }
    
}

//func saveBeforeBedAnswers(Timestamp:Date,
//                          ExerciseQuestion:Bool,
//                          DinnerQuestion:Int,
//                          SexQuestion:Bool,
//                          StimulantQuestion:String,
//                          NakedQuestion:Bool,
//                          WaterQuestion:Bool,
//                          NightDeviceQuestion:Bool,
//                          NightTiredQuestion:Bool) {
//    
//    try! realm.write {
//        let newData = beforeBedAnswersObject(value: ["Timestamp": Timestamp,
//                                                 "ExerciseQuestion": ExerciseQuestion,
//                                                 "DinnerQuestion": DinnerQuestion,
//                                                 "SexQuestion": SexQuestion,
//                                                 "StimulantQuestion": StimulantQuestion,
//                                                 "NakedQuestion": NakedQuestion,
//                                                 "WaterQuestion": WaterQuestion,
//                                                 "NightDeviceQuestion": NightDeviceQuestion,
//                                                 "NightTiredQuestion": NightTiredQuestion])
//        currentUser.sleepData.append(newData)
//        realm.add(currentUser, update: true)
//        print("Added sleepData object to database: \(newData)")
//    }
//    
//}

//func saveAfterBedAnswers(Timestamp:Date,
//                         WakeLightQuestion:Bool,
//                         ToiletQuestion:Bool,
//                         NightLightQuestion:Bool,
//                         WakeDeviceQuestion:Bool,
//                         WakeTiredQuestion:Bool,
//                         WakeSleepQuestion:Bool) {
//    
//    try! realm.write {
//        let newData = afterBedAnswersObject(value: ["Timestamp": Timestamp,
//                                              "WakeLightQuestion": WakeLightQuestion,
//                                              "ToiletQuestion": ToiletQuestion,
//                                              "NightLightQuestion": NightLightQuestion,
//                                              "WakeDeviceQuestion": WakeDeviceQuestion,
//                                              "WakeTiredQuestion": WakeTiredQuestion,
//                                              "WakeSleepQuestion": WakeSleepQuestion])
//        currentUser.sleepData.append(newData)
//        realm.add(currentUser, update: true)
//        print("Added sleepData object to database: \(newData)")
//    }
//}


//func saveSample(Timestamp:Date,
//                sensorTag:String,
//                sampleTemp:Float,
//                sampleHumi:Float,
//                sampleLight:Float,
//                sampleAccX:Float,
//                sampleAccY:Float,
//                sampleAccZ:Float,
//                currentUser:User) {
//    
//    try! realm.write {
//        let newData = sensorDataObject(value: [ "sensorID": sensorTag,
//                                                "Timestamp": Timestamp,
//                                                "sensorTemp": sampleTemp,
//                                                "sensorHumi": sampleHumi,
//                                                "sensorLight":sampleLight,
//                                                "sensorAccX": sampleAccX,
//                                                "sensorAccY": sampleAccY,
//                                                "sensorAccZ": sampleAccZ ]
//                                        )
//        
//        currentUser.sleepData.last?.sensorData.append(newData)
//        realm.add(currentUser, update: true)
//        print("Added sensorData object to database: \(newData)")
//    }
//}

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
    
//    let credentials = SyncCredentials.usernamePassword(username: newUser.email, password: newUser.password)
//    SyncUser.logIn(with: credentials,
//                   server: serverURL) { user, error in
//                    if let user = user {
//                        // can now open a synchronized Realm with this user
//                    } else if let error = error {
//                        // handle error
//                    }
//    }
    
    try! realm.write {
        realm.add(newUser)
        print("Added User object to database: \(newUser)")
    }

}
