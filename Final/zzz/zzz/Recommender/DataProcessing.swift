//
//  DataProcessing.swift
//  zzz
//
//  Created by Xavier Laguarta Soler on 12/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import RealmSwift

func LightAccThreshold() -> Int {
    let light_threshold = 1
    let acc_threshold = 0.4
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


func adjustWeight(classifier: String, result: Int) -> Float {
    let currentWeights = realm.objects(User.self).filter("email = '\(currentUser.email)'")[0].weightsData!
    let QualitativeData = realm.objects(sleepDataObject.self)
    let lastQualitativeDataAfter = QualitativeData.last!.afterBedAnswers
    
    let sleepData = lastQualitativeDataAfter?.WakeSleepQuestion
    if sleepData?.value == true {
        switch classifier{
        case "hot":
            let currentHotWeight = currentWeights.weightHot
            
            var hotWeight = currentHotWeight
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                hotWeight = decrementWeight(currentWeight: hotWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                hotWeight = decrementWeight(currentWeight: hotWeight)
            case 2:
                // temperature is too low: increase cold, set hot to 0
                hotWeight = 0
            default:
                hotWeight = currentHotWeight
            }
            return hotWeight
        
        case "cold":
            let currentColdWeight = currentWeights.weightCold
            //let currentHotWeight = currentWeights.weightHot
            
            //var hotWeight = currentHotWeight
            var coldWeight = currentColdWeight
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                coldWeight = decrementWeight(currentWeight: coldWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                coldWeight = 0
            case 2:
                // temperature is too low: increase cold, set hot to 0
                coldWeight = decrementWeight(currentWeight: coldWeight)
            default:
                coldWeight = currentColdWeight
            }
            return coldWeight

            
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
                humidityWeight = currentHumidWeight
            }
            return humidityWeight
            
            
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
                waterWeight = currentWaterWeight
            }
        // TODO: write new water weight
            return waterWeight

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
                exerciseWeight = currentExerciseWeight
            }
        // TODO: write new exercise weight
            return exerciseWeight
    
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
                sexWeight = currentSexWeight
            }
        // TODO: write new exercise weight
            return sexWeight
            
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
                coffeeWeight = currentCoffeeWeight

            }
            return coffeeWeight

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
                alcoholWeight = currentAlcoholWeight

            }
            return alcoholWeight
            
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
                mealWeight = currentMealWeight

            }
            return mealWeight
  
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
                lightWeight = currentLightWeight

            }
            return lightWeight
        default:
            ()
        }
    }
    else{
        switch classifier{
        
        case "hot":
            let currentColdWeight = currentWeights.weightCold
            print(currentColdWeight)
            let currentHotWeight = currentWeights.weightHot
            
            var hotWeight = currentHotWeight
            print(hotWeight)
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                hotWeight = decrementWeight(currentWeight: hotWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                hotWeight = incrementWeight(currentWeight: hotWeight)
            case 2:
                // temperature is too low: increase cold, set hot to 0
                hotWeight = 0
            default:
                hotWeight = currentHotWeight

            }
            return hotWeight
        
        case "cold":
            let currentColdWeight = currentWeights.weightCold
            print(currentColdWeight)
            
            var coldWeight = currentColdWeight
            switch result{
            case 0:
                // temperature fine: decrement both hot and cold
                coldWeight = decrementWeight(currentWeight: coldWeight)
            case 1:
                // temperature is too high: increase hot, set cold to 0
                coldWeight = 0
            case 2:
                // temperature is too low: increase cold, set hot to 0
                coldWeight = incrementWeight(currentWeight: coldWeight)
            default:
                coldWeight = currentColdWeight

            }
            return coldWeight
            
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
                humidityWeight = currentHumidWeight

            }
            return humidityWeight

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
                waterWeight = currentWaterWeight

            }
        // TODO: write new water weight
            return waterWeight
            
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
                exerciseWeight = currentExerciseWeight
            }
            return exerciseWeight
            
        
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
                sexWeight = currentSexWeight

            }
            return sexWeight
        
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
                coffeeWeight = currentCoffeeWeight

            }
            return coffeeWeight
        
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
                alcoholWeight = currentAlcoholWeight

            }
            return alcoholWeight
            
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
                mealWeight = currentMealWeight

            }
            return mealWeight
            
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
                lightWeight = currentLightWeight

            }
            return lightWeight
        default:
            ()
        }
    }
    return 100
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
        
        
        let light_classified = LightAccThreshold()
        
        
        let QualitativeData = realm.objects(sleepDataObject.self)
        let lastQualitativeDataBefore = QualitativeData.last!.beforeBedAnswers
        let humid_classified = humidClassifier(humid_mean: humid_mean, humid_max: humid_max)
        let temp_classified = tempClassifier(temp_mean: temp_mean, temp_max: temp_max)
        let hot_classified = temp_classified
        let cold_classified = temp_classified
        // results before sleep Data
        
        //exercise data
        let exerciseData = lastQualitativeDataBefore?.ExerciseQuestion
        if exerciseData?.value == nil{
            exercise_classified = 4;
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
        var stimulantData = lastQualitativeDataBefore!.StimulantsQuestion!
        if (stimulantData == "[]") {
            alcohol_classified = 2
            nicotine_classified = 2
            coffee_classified = 2
        }else{
            stimulantData.remove(at: stimulantData.startIndex)
            stimulantData = stimulantData.substring(to: stimulantData.index(before: stimulantData.endIndex))
            let stimulants = stimulantData.components(separatedBy: ", ")
            
            for stimulant in stimulants as [String] {
            if stimulant == "alcohol"{
                alcohol_classified = 1;
            }
            else{
                alcohol_classified = 0;
            }
            if stimulant == "tobacco"{
                nicotine_classified = 1;
            }
            else{
                nicotine_classified = 0;
            }
            if stimulant == "coffee"{
                coffee_classified = 1;
            }
            else{
                coffee_classified = 0;
            }
        }
        }
        
        
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
        let hot_classifier = adjustWeight(classifier: "hot", result: hot_classified)
        let cold_classifier = adjustWeight(classifier: "cold", result: cold_classified)
        let light_classifier = adjustWeight(classifier: "light", result: light_classified)
        let humid_classifier = adjustWeight(classifier: "humidity", result: humid_classified)
        let water_classifier = adjustWeight(classifier: "water", result: water_classified)
        let exercise_classifier = adjustWeight(classifier: "exercise", result: exercise_classified)
        let sex_classifier = adjustWeight(classifier: "sex", result: sex_classified)
        let coffee_classifier = adjustWeight(classifier: "coffee", result: coffee_classified)
        let alcohol_classifier = adjustWeight(classifier: "alcohol", result: alcohol_classified)
        let meal_classifier = adjustWeight(classifier: "meal", result: meal_classified)
        
        let newWeights = weightsDataObject(value: ["weightHot": hot_classifier,
                                                   "weightCold": cold_classifier,
                                                   "weightHumi": humid_classifier,
                                                   "weightWater": water_classifier,
                                                   "weightExercise": exercise_classifier,
                                                   "weightSex": sex_classifier,
                                                   "weightMeal": meal_classifier,
                                                   "weightAlcohol": alcohol_classifier,
                                                   "weightLight": light_classifier,
                                                   "weightCof": coffee_classifier])
            
        saveWeightData(newWeightData: newWeights)
}
}

