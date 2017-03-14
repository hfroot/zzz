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

    var classifier = 1

//    let dict = ["temp_mean": temp_mean, "temp_max": temp_max] as [String: Any]
//    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)


//    var request = URLRequest(url: URL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!)
    
    //You can pass any required content types here
//    request.httpMethod = "GET"
//    request.httpBody = jsonData
    

//    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
                
//        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.httpBody = jsonData
        
//        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
//            if error != nil{
//                print(error?.localizedDescription as Any)
//                return
//            }
//            do {
//                if let data = data,
//                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                    let result = json["temp_classifier"] as? Int {
//                    print("classifier received from API: \(result)")
//                    classifier = result
//                }
//            } catch {
//                print("Error deserializing JSON: \(error)")
//            }
//        }
    //}
    //catch {
        //print("json error: \(error)")
    //}
//    }.resume()

    return classifier
}


func connectToHumidServer (humid_mean: Float, humid_max: Float) -> Int {
    
    var classifier:Int?
    
    let dict = ["humid_mean": humid_mean, "humid_max": humid_max] as [String: Any]
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
        
        
        let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/humidity")!
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
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    //let resultValue:String = parseJSON["success"] as! String;
                    //print("result: \(resultValue)")
                    classifier = parseJSON["humid_classifier"] as? Int
                }
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    return classifier!
}

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


func adjustWeight(classifier: String, result: Int) {
    let currentWeights = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].weightsData!
    let QualitativeData = realm.objects(sleepDataObject.self)
    let lastQualitativeDataAfter = QualitativeData.last!.afterBedAnswers
    
    let newWeights = weightsDataObject()
    
    print(currentWeights)
    
    let sleepData = lastQualitativeDataAfter?.WakeSleepQuestion
    if sleepData?.value == true {
        switch classifier{
        case "temperature":
            let currentColdWeight = currentWeights.weightCold
            let currentHotWeight = currentWeights.weightHot
            
            var hotWeight = currentHotWeight
            var coldWeight = currentColdWeight
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                hotWeight = decrementWeight(currentWeight: hotWeight)
                coldWeight = decrementWeight(currentWeight: coldWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                hotWeight = decrementWeight(currentWeight: hotWeight)
                coldWeight = 0
            case 2:
                // temperature is too low: increase cold, set hot to 0
                coldWeight = decrementWeight(currentWeight: coldWeight)
                hotWeight = 0
            default:
                ()
            }
        // TODO: write new temperature weights
            newWeights.weightHot = hotWeight
            newWeights.weightCold = coldWeight
            
        case "humidity":
            let currentHumidWeight = currentWeights.weightHumi
            var humidityWeight = currentHumidWeight
            switch result{
            case 0:
                // humidity is fine: decrement weight
                humidityWeight = decrementWeight(currentWeight: humidityWeight)
            case 1:
                // humidity is too high: increment weight
                humidityWeight = decrementWeight(currentWeight: humidityWeight)
            case 2:
                // humidity is too low: not implemented yet
                ()
            default:
                ()
            }
            newWeights.weightHumi = humidityWeight
            
            
        case "water":
            let currentWaterWeight = currentWeights.weightWater
            var waterWeight = currentWaterWeight
            switch result{
            case 0:
                // water is fine: decrement weight
                waterWeight = decrementWeight(currentWeight: waterWeight)
            case 1:
                // water is too high: increment weight
                waterWeight = decrementWeight(currentWeight: waterWeight)
            default:
                ()
            }
        // TODO: write new water weight
            newWeights.weightWater = waterWeight
            
        case "exercise":
            let currentExerciseWeight = currentWeights.weightExercise
            var exerciseWeight = currentExerciseWeight
            switch result{
            case 0:
                //  exercise is fine: decrement weight
                exerciseWeight = decrementWeight(currentWeight: exerciseWeight)
            case 1:
                // exercise is too high: increment weight
                exerciseWeight = decrementWeight(currentWeight: exerciseWeight)
            default:
                ()
            }
        // TODO: write new exercise weight
            newWeights.weightExercise = exerciseWeight
    
        case "sex":
            let currentSexWeight = currentWeights.weightSex
            var sexWeight = currentSexWeight
            switch result{
            case 0:
                //  sex is fine: decrement weight
                sexWeight = decrementWeight(currentWeight: sexWeight)
            case 1:
                // sex is too high: increment weight
                sexWeight = decrementWeight(currentWeight: sexWeight)
            default:
                ()
            }
        // TODO: write new exercise weight
            newWeights.weightSex = sexWeight
            
        case "coffee":
            let currentCoffeeWeight = currentWeights.weightCof
            var coffeeWeight = currentCoffeeWeight
            switch result{
            case 0:
                //  coffee is fine: decrement weight
                coffeeWeight = decrementWeight(currentWeight: coffeeWeight)
            case 1:
                // coffee is too high: increment weight
                coffeeWeight = decrementWeight(currentWeight: coffeeWeight)
            default:
                ()
            }
            newWeights.weightCof = coffeeWeight

        case "alcohol":
            let currentAlcoholWeight = currentWeights.weightAlcohol
            var alcoholWeight = currentAlcoholWeight
            switch result{
            case 0:
                //  alcohol is fine: decrement weight
                alcoholWeight = decrementWeight(currentWeight: alcoholWeight)
            case 1:
                // alcohol is too high: increment weight
                alcoholWeight = decrementWeight(currentWeight: alcoholWeight)
            default:
                ()
            }
            newWeights.weightAlcohol = alcoholWeight
            
        case "meal":
            let currentMealWeight = currentWeights.weightMeal
            var mealWeight = currentMealWeight
            switch result{
            case 0:
                //  alcohol is fine: decrement weight
                mealWeight = decrementWeight(currentWeight: mealWeight)
            case 1:
                // alcohol is too high: increment weight
                mealWeight = decrementWeight(currentWeight: mealWeight)
            default:
                ()
            }
            newWeights.weightMeal = mealWeight
            
  
        case "light":
            let currentLightWeight = currentWeights.weightLight
            var lightWeight = currentLightWeight
            switch result{
            case 0:
                // light is fine: decrement weight
                lightWeight = decrementWeight(currentWeight: lightWeight)
            case 1:
                // light is too high: increment weight
                lightWeight = decrementWeight(currentWeight: lightWeight)
            default:
                ()
            }
            newWeights.weightLight = lightWeight
        default:
            ()
        }
    }
    else{
        switch classifier{
        case "temperature":
            let currentColdWeight = currentWeights.weightCold
            print(currentColdWeight)
            let currentHotWeight = currentWeights.weightHot
            
            var hotWeight = currentHotWeight
            print(hotWeight)
            var coldWeight = currentColdWeight
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                hotWeight = decrementWeight(currentWeight: hotWeight)
                coldWeight = decrementWeight(currentWeight: coldWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                hotWeight = incrementWeight(currentWeight: hotWeight)
                coldWeight = 0
            case 2:
                // temperature is too low: increase cold, set hot to 0
                coldWeight = incrementWeight(currentWeight: coldWeight)
                hotWeight = 0
            default:
                ()
            }
            newWeights.weightCold = coldWeight
            newWeights.weightHot = hotWeight
            
            
        case "humidity":
            let currentHumidWeight = currentWeights.weightHumi
            var humidityWeight = currentHumidWeight
            switch result{
            case 0:
                // humidity is fine: decrement weight
                humidityWeight = decrementWeight(currentWeight: humidityWeight)
            case 1:
                // humidity is too high: increment weight
                humidityWeight = incrementWeight(currentWeight: humidityWeight)
            case 2:
                // humidity is too low: not implemented yet
                ()
            default:
                ()
            }
            newWeights.weightHumi = humidityWeight

        case "water":
            let currentWaterWeight = currentWeights.weightWater
            var waterWeight = currentWaterWeight
            switch result{
            case 0:
                // water is fine: decrement weight
                waterWeight = decrementWeight(currentWeight: waterWeight)
            case 1:
                // water is too high: increment weight
                waterWeight = incrementWeight(currentWeight: waterWeight)
            default:
                ()
            }
        // TODO: write new water weight
            newWeights.weightWater = waterWeight
            
        case "exercise":
            let currentExerciseWeight = currentWeights.weightExercise
            var exerciseWeight = currentExerciseWeight
            switch result{
            case 0:
                //  exercise is fine: decrement weight
                exerciseWeight = decrementWeight(currentWeight: exerciseWeight)
            case 1:
                // exercise is too high: increment weight
                exerciseWeight = incrementWeight(currentWeight: exerciseWeight)
            default:
                ()
            }
            newWeights.weightExercise = exerciseWeight
            
        
        case "sex":
            let currentSexWeight = currentWeights.weightSex
            var sexWeight = currentSexWeight
            switch result{
            case 0:
                //  sex is fine: decrement weight
                sexWeight = decrementWeight(currentWeight: sexWeight)
            case 1:
                // sex is too high: increment weight
                sexWeight = incrementWeight(currentWeight: sexWeight)
            default:
                ()
            }
            newWeights.weightSex = sexWeight
            
        
        case "coffee":
            let currentCoffeeWeight = currentWeights.weightCof
            var coffeeWeight = currentCoffeeWeight
            switch result{
            case 0:
                //  coffee is fine: decrement weight
                coffeeWeight = decrementWeight(currentWeight: coffeeWeight)
            case 1:
                // coffee is too high: increment weight
                coffeeWeight = incrementWeight(currentWeight: coffeeWeight)
            default:
                ()
            }
            newWeights.weightCof = coffeeWeight
            
        
        case "alcohol":
            let currentAlcoholWeight = currentWeights.weightAlcohol
            var alcoholWeight = currentAlcoholWeight
            switch result{
            case 0:
                //  alcohol is fine: decrement weight
                alcoholWeight = decrementWeight(currentWeight: alcoholWeight)
            case 1:
                // alcohol is too high: increment weight
                alcoholWeight = incrementWeight(currentWeight: alcoholWeight)
            default:
                ()
            }
            newWeights.weightAlcohol = alcoholWeight
            
            
        case "meal":
            let currentMealWeight = currentWeights.weightMeal
            var mealWeight = currentMealWeight
            switch result{
            case 0:
                //  alcohol is fine: decrement weight
                mealWeight = decrementWeight(currentWeight: mealWeight)
            case 1:
                // alcohol is too high: increment weight
                mealWeight = incrementWeight(currentWeight: mealWeight)
            case 2:
                // alcohol is too high: increment weight
                mealWeight = incrementWeight(currentWeight: mealWeight)
            case 3:
                // alcohol is too high: increment weight
                mealWeight = incrementWeight(currentWeight: mealWeight)
            default:
                ()
            }
            newWeights.weightMeal = mealWeight
            
            
            case "light":
            let currentLightWeight = currentWeights.weightLight
            var lightWeight = currentLightWeight
            switch result{
            case 0:
                // light is fine: decrement weight
                lightWeight = decrementWeight(currentWeight: lightWeight)
            case 1:
                // light is too high: increment weight
                lightWeight = incrementWeight(currentWeight: lightWeight)
            default:
                ()
            }
            newWeights.weightLight = lightWeight
        default:
            ()
        }
    }
    
    
    saveWeightData(newWeightData: newWeights)
}



func incrementWeight(currentWeight: Float) -> Float{
    var newWeight = 0.0
    if ((currentWeight >= 0 && currentWeight < 0.1) || (currentWeight >= 0.925 && currentWeight < 1)){
        newWeight = Double(currentWeight) + 0.025
    }
    else if ((currentWeight >= 0.1 && currentWeight < 0.225) || (currentWeight >= 0.8 && currentWeight < 0.925)){
        newWeight = Double(currentWeight) + 0.05
    }
    else if ((currentWeight >= 0.225 && currentWeight < 0.325) || (currentWeight >= 0.7 && currentWeight < 0.8)){
        newWeight = Double(currentWeight) + 0.075
    }
    else if ((currentWeight >= 0.325 && currentWeight < 0.4) || (currentWeight >= 0.625 && currentWeight < 0.7)){
        newWeight = Double(currentWeight) + 0.1
    }
    else if ((currentWeight >= 0.4 && currentWeight < 0.625)){
        newWeight = Double(currentWeight) + 0.125
    }
    else if (currentWeight < 0){
        newWeight = 0
    }
    else if (currentWeight > 1){
        newWeight = 1
    }
    return Float(newWeight)
}

func decrementWeight(currentWeight: Float) -> Float{
    let newWeight = Double(currentWeight) - 0.1
    return Float(newWeight)
}


func processData(){
    print("processing data")
    //    let calendar = Calendar.current
    //    let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
    //    let today = Date()
    
    let currentUserData = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].sleepData//.filter("Timestamp > %@ AND Timestamp <= %@", yesterday!, today)
    let lastNightData = currentUserData.last!.sensorData
    
    var water_classified = Int()
    var exercise_classified = Int()
    var sex_classified = Int()
    var coffee_classified = Int()
    var alcohol_classified = Int()
    var meal_classified = Int()
    var nicotine_classified = Int()
    
    if lastNightData.isEmpty {
        print("No data data has been recorded last night")
    }
    else {
        
        let temp_max:Float = lastNightData.max(ofProperty: "sensorTemp")!
        let temp_mean:Float = lastNightData.average(ofProperty: "sensorTemp")!

        
        let humid_max:Float = lastNightData.max(ofProperty: "sensorHumi")!
        let humid_mean:Float = lastNightData.average(ofProperty: "sensorHumi")!
        
        // Send to API and retrieve corresponding classifier for temp and humi
        let temp_classified:Int = connectToTempServer(temp_mean: temp_mean, temp_max: temp_max)
        //        let humid_classified = connectToHumidServer(humid_mean: humid_mean, humid_max: humid_max )
        print(temp_classified)
        
        //let humid_classified = connectToHumidServer(humid_mean: humid_mean, humid_max: humid_max )
        //print(humid_classified)
        
        let light_classified = LightAccThreshold()
        
        
        let QualitativeData = realm.objects(sleepDataObject.self)
        let lastQualitativeDataBefore = QualitativeData.last!.beforeBedAnswers
        let lastQualitativeDataAfter = QualitativeData.last!.afterBedAnswers
        
        
        
        // results before sleep Data
        
        //exercise data
        let exerciseData = lastQualitativeDataBefore?.ExerciseQuestion
        if exerciseData?.value == nil{
            var exercise_classified = 4;
        }

        if exerciseData?.value == true{
            exercise_classified = 1;
        }
        else{
            exercise_classified = 0;
        }
        
        let dinnerData = lastQualitativeDataBefore?.DinnerQuestion
        if dinnerData?.value == Float(0.5){
            meal_classified = 0;
        }
        else if dinnerData?.value == Float(1){
            meal_classified = 1;
        }
        else if dinnerData?.value == Float(2){
            meal_classified = 2;
        }else if dinnerData?.value == Float(3){
            meal_classified = 3;
        }

        
        //sex data
        let sexData = lastQualitativeDataBefore?.SexQuestion
        if sexData?.value == nil {
            sex_classified = 2;
        }
        else if sexData?.value == true{
            sex_classified = 1;
        }
        else{
            sex_classified = 0;
        }
        
        //alcohol, coffee, nicotine
//        let stimulantData = lastQualitativeDataBefore?.StimulantsQuestion
//        if (stimulantData?.isEmpty)! {
//            let alcohol_classified = 2
//            let nicotine_classified = 2
//            let coffee_classified = 2
//        }else{
//        for stimulant in (stimulantData?.characters)!{
//            if stimulant == "alcohol"{
//                alcohol_classified = 1;
//            }
//            else{
//                alcohol_classified = 0;
//            }
//            if stimulant == "tobacco"{
//                nicotine_classified = 1;
//            }
//            else{
//                nicotine_classified = 0;
//            }
//            if stimulant == "coffee"{
//                coffee_classified = 1;
//            }
//            else{
//                coffee_classified = 0;
//            }
//        }
//        }
        
        
        //drink water
        let waterData = lastQualitativeDataBefore?.WaterQuestion
        if waterData?.value == nil{
            water_classified = 2;
        }
        else if waterData?.value == true{
            water_classified = 1;
        }
        else{
            water_classified = 0;
        }
        
        
        
        // call the adjustWeight
        adjustWeight(classifier: "temperature", result: temp_classified)
        adjustWeight(classifier: "light", result: light_classified)
        //adjustWeight(classifier: "humidity", result: humid_classified)
        adjustWeight(classifier: "water", result: water_classified)
        adjustWeight(classifier: "exercise", result: exercise_classified)
        adjustWeight(classifier: "sex", result: sex_classified)
        //adjustWeight(classifier: "coffee", result: coffee_classified)
        //adjustWeight(classifier: "alcohol", result: alcohol_classified)
        adjustWeight(classifier: "meal", result: meal_classified)
        //adjustWeight(classifier: "duration", result: duration_classified)
        

        
        
    }
}

