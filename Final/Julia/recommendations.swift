//
//  recommendations.swift
//
//  Created by Julia Booth on 3/8/17.
//
//  This is the recommendation engine for the zzz app
//  The recommendation engine imports the suggestion engine
//

import Foundation

class RecommendationEngine{
    
    var factorWeights: [String:Double] = ["duration": 0.6,
                                          "exercise": 0.6,
                                          "caffeine": 0.5,
                                          "meal": 0.3,
                                          "nicotine": 0.4,
                                          "alcohol": 0.4,
                                          "relaxation": 0.3,
                                          "light": 0.6,
                                          "noise": 0.6,
                                          "heat": 0.5,
                                          "cold": 0.5,
                                          "humidity" :0.3,
                                          "device": 0.5]
    var suggestion = SuggestionEngine()
    
    func setSuggestionSetting(setting: String, value: Int){
        switch setting{
        case "exerciseLevel":
            if (value != 0 && value != 1 && value != 2){
                return
            }
            suggestion.exerciseLevel = value    // 0 = no exercise, 1 = small amount of exercise, 2 = regular exercise
        case "drinksCoffee":
            if (value != 0 && value != 1){
                return
            }
            suggestion.drinksCoffee = value     // binary: 0 = false, 1 = true
        case "isSmoker":
            if (value != 0 && value != 1){
                return
            }
            suggestion.isSmoker = value         // binary: 0 = false, 1 = true
        case "isTooHot":
            if (value != 0 && value != 1){
                return
            }
            suggestion.isTooHot = value         // binary: 0 = false, 1 = true
        case "deviceEffect":
            if (value != 0 && value != 1){
                return
            }
            suggestion.deviceEffect = value     // 0 = minor effect, 1 = major effect
        default:
            return
        }
    }
    
    func getAdvice() -> String{
        var tempWeights = factorWeights
        var found: Bool = false
        var index: String = "duration"
        var advice: String = "no more advice to give"
        while found == false {
            for (key, value) in factorWeights{
                if value == factorWeights.values.max(){
                    index = key
                }
            }
            advice = suggestion.getSuggestion(group: index)
            if advice == "empty advice"{
                tempWeights.removeValue(forKey: index)
                if tempWeights.isEmpty{
                    advice = "no more advice to give"
                    found = true
                }
            }
            else{
                found = true
            }
        }
        return advice
    }
    
    func rejectAdvice(){
        suggestion.removeSuggestion()
    }
}
