//
//  DataProcessing.swift
//  zzz
//
//  Created by Xavier Laguarta Soler on 12/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import RealmSwift

//func ProcessTemperatureMax(currentUserData : sensorDataObject)-> Float {
//    let temp_max:Float = currentUserData.max(ofProperty: "sensorTemp")!
//    print(temp_max)
//    return temp_max
//}
//
//func ProcessTemperatureMean(currentUserData : sensorDataObject)-> Float {
//    let temp_mean:Float = currentUserData.average(ofProperty: "sensorTemp")!
//    print(temp_mean)
//    return temp_mean
//}
//
//
//func ProcessHumidityMax(currentUserData : sensorDataObject)-> Float{
//    let humid_max:Float = currentUserData.max(ofProperty: "sensorHumi")!
//    print(humid_max)
//    return humid_max
//}
//
//func ProcessHumidityMean(currentUserData : sensorDataObject)-> Float{
//    let humid_mean:Float = currentUserData.average(ofProperty: "sensorHumi")!
//    print(humid_mean)
//    return humid_mean
//}

func connectToTempServer (temp_mean: Float, temp_max: Float) -> Int {
    
    var classifier = Int()
    
    let dict = ["temp_mean": temp_mean, "temp_max": temp_max] as [String: Any]
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
        
        print(jsonData)
        
        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let data:Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let result = json["temp_classifier"] as? Int {
                    classifier = result
                    print(classifier)
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
        
        
        
    }
    return classifier
}

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



func processData(){
    let calendar = Calendar.current
    //let today = calendar.date(byAdding: .day, value: -1, to: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
    
    let today = Date()
    //let to = yesterday
    
    //let query = realm.objects(User).filter("email" == currentUser.email)
    let currentUserData = realm.objects(User.self.self).filter("email = '\(currentUser.email)'")[0].sensorData.filter("sensorTimestamp > %@ AND sensorTimestamp <= %@", yesterday!, today)
    
    if currentUserData.isEmpty {
        print("No data data has been recorded tonight")
    }
    else {
        
        //Find mean max value
        let temp_max:Float = currentUserData.max(ofProperty: "sensorTemp")!
        print(temp_max)
        
        let temp_mean:Float = currentUserData.average(ofProperty: "sensorTemp")!
        print(temp_mean)
        
        let humid_max:Float = currentUserData.max(ofProperty: "sensorHumi")!
        print(humid_max)
        
        let humid_mean:Float = currentUserData.average(ofProperty: "sensorHumi")!
        print(humid_mean)
        
        // Send to API and retrieve corresponding classifier for temp and humi
        let temp_classified = connectToTempServer(temp_mean: temp_mean, temp_max: temp_max)
        //        let humid_classified = connectToHumidServer(humid_mean: humid_mean, humid_max: humid_max )
        print(temp_classified)
        //        print(humid_classified)
        //        let light_threshold = 1
        //        let acc_threshold = 1
        //        let light_acc_threshold = currentUserData.filter("sensorLight > %@ AND sensorAccX > %@", light_threshold; acc_threshold)
        //        if light_acc_threshold.isEmpty == false{
        //            let acc_light_correlation = true
        //        }
        
        
    }
    
    //    let AV_temp = ProcessTemperatureMean(currentUserData: sensorDataObject)
    //    let MAX_temp = ProcessTemperatureMax(currentUserData: sensorDataObject)
    //    let AV_humid = ProcessHumidityMean(currentUserData: <#T##sensorDataObject#>)
    //    let MAX_humid = ProcessHumidityMax(currentUserData: <#T##sensorDataObject#>)
    
}
