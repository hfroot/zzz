//
//  DataProcessing.swift
//  zzz
//
//  Created by Xavier Laguarta Soler on 12/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import RealmSwift


func connectToTempServer (temp_mean: Float, temp_max: Float) -> Int {
    var classifier = 3

    let dict = ["temp_mean": temp_mean, "temp_max": temp_max] as [String: Any]
    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    

    var request = URLRequest(url: URL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!)
    
    //You can pass any required content types here
    request.httpMethod = "GET"
    request.httpBody = jsonData
    

    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
                
        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let result = json["temp_classifier"] as? Int {
                    print("classifier received from API: \(result)")
                    classifier = result
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
    }
    catch {
        print("json error: \(error)")
    }
    }.resume()
return classifier
}


    




//func connectToTempServer (temp_mean: Float, temp_max: Float) -> Int {
//    
//    var classifier = 3
//    
//    let dict = ["temp_mean": temp_mean, "temp_max": temp_max] as [String: Any]
//    
//    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
//                
//        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.httpBody = jsonData
//        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
//            if error != nil{
//                print(error?.localizedDescription as Any)
//                return
//            }
//            
//            do {
//
//                if let data = data,
//                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                    let result:Int = json["temp_classifier"] as? Int {
//                    //print(result)
//                    classifier = result
//                    }
//                }
//            catch {
//                print("Error deserializing JSON: \(error)")
//            }
//            }
//        task.resume()
//        }
//    
//    return classifier
//}


//func connectToHumidServer (humid_mean: Float, humid_max: Float) -> Int {
//
//    var classifier:Int?
//
//    let dict = ["humid_mean": humid_mean, "humid_max": humid_max] as [String: Any]
//
//    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
//
//
//        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/humidity")!
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
//            if error != nil{
//                print(error?.localizedDescription as Any)
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                if let parseJSON = json {
//                    //let resultValue:String = parseJSON["success"] as! String;
//                    //print("result: \(resultValue)")
//                    classifier = parseJSON["humid_classifier"] as? Int
//                }
//            } catch let error as NSError {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//    return classifier!
//}

func LightAccThreshold() -> Int {
    let light_threshold = 1
    let acc_threshold = 1
    var light_effect = Int()
    
    let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData//.filter("Timestamp > %@ AND Timestamp <= %@", yesterday!, today)
    let lastNightData = currentUserData.last!.sensorData

    
    if lastNightData.isEmpty {
        print("No data data has been recorded tonight")
    }
    else {
        
        let light_acc_threshold = lastNightData.filter("sensorLight > %@ AND sensorAccX > %@", light_threshold, acc_threshold)
        if light_acc_threshold.isEmpty{
            light_effect = 0
        }
        else{
            light_effect = 1
        }
    }
    return light_effect
}


func processData(){
    print("processing data")
//    let calendar = Calendar.current
//    let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
//    let today = Date()
    
    let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData//.filter("Timestamp > %@ AND Timestamp <= %@", yesterday!, today)
    let lastNightData = currentUserData.last!.sensorData

    
    if lastNightData.isEmpty {
        print("No data data has been recorded last night")
    }
    else {
        
        let temp_max:Float = lastNightData.max(ofProperty: "sensorTemp")!
        let temp_mean:Float = lastNightData.average(ofProperty: "sensorTemp")!
        print(temp_max)
        print(temp_mean)
        
        //let humid_max:Float = lastNightData.max(ofProperty: "sensorHumi")!
        //let humid_mean:Float = lastNightData.average(ofProperty: "sensorHumi")!
        
        // Send to API and retrieve corresponding classifier for temp and humi

        let temp_classified:Int = connectToTempServer(temp_mean: temp_mean, temp_max: temp_max)
        //        let humid_classified = connectToHumidServer(humid_mean: humid_mean, humid_max: humid_max )
        print(temp_classified)
//                let humid_classified = connectToHumidServer(humid_mean: humid_mean, humid_max: humid_max )
//                print(humid_classified)
        let light_effect = LightAccThreshold()
        print(light_effect)
        
        
//        let currentWeights = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].weightsData
//        let coldWeight = currentWeights?.weightCold
//        let hotWeight = currentWeights?.weightHot
//        let sexWeight = currentWeights?.weightSex
//        let humidWeight = currentWeights?.weightHumi
//        let coffeeWeight = currentWeights?.weightCof
//        let alcoholWeight = currentWeights?.weightAlcohol
//        let mealWeight = currentWeights?.weightMeal
//        let durationWeight = currentWeights?.weightDuration
//        let exerciseWeight = currentWeights?.weightExercise
//        let waterWeight = currentWeights?.weightWater
//        let lightWeight = currentWeights?.weightLight
//        
//        //we must process the weights with classification results obtained
//        
//        try! realm.write {
//            currentWeights?.weightLight = 0.7
//            currentWeights?.weightWater = 0.8
//        }
    }
    
}
