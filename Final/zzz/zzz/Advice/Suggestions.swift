//
//  suggestions.swift
//
//  Created by Julia Booth on 3/8/17.
//
//  This is the suggestion engine for the zzz app
//  getSuggestion(group: String) takes as input the group of the suggestion wanted
//      and returns a string which is the suggestion to display to the user
//

import Foundation

struct Suggestion{
    var advice: String
    var subgroup: Int
}

class SuggestionEngine{
    // initialise the suggestion array
    var duration = [Suggestion(advice:"try to sleep for an extra hour tonight",subgroup:1),
                    Suggestion(advice:"try to go to sleep an hour earlier tonight",subgroup:1)]
    var exercise = [Suggestion(advice:"continue to exercise regularly",subgroup:4),
                    Suggestion(advice:"try to go for a 40 minute jog today",subgroup:3),
                    Suggestion(advice:"try to go running for 30 minutes today",subgroup:3),
                    Suggestion(advice:"try going running for an hour today",subgroup:3),
                    Suggestion(advice:"try to go on a gentle jog for 20 minutes today",subgroup:2)]
    var caffeine = [Suggestion(advice:"try cutting down your coffee today",subgroup:5),
                    Suggestion(advice:"try not to drink coffee after 5pm",subgroup:5)]
    var meal = [Suggestion(advice:"make sure your supper has a good mix of carbohydrates and protein",subgroup:6),
                Suggestion(advice:"make sure you eat at least one portion of vegatables at supper",subgroup:6),
                Suggestion(advice:"make sure your supper is low in sugar",subgroup:6),
                Suggestion(advice:"remember, do not make your supper portion too big, you will be too full to sleep",subgroup:7),
                Suggestion(advice:"eat at least 4 hours before you plan to go to bed",subgroup:7)]
    var alcohol = [Suggestion(advice:"try to drink fewer units of alcohol this evening",subgroup:9),
                   Suggestion(advice:"avoid consuming alcohol after 11pm",subgroup:9)]
    var light = [Suggestion(advice:"try to make your room as dark as possible",subgroup:14),
                 Suggestion(advice:"try better blinds/curtains",subgroup:14)]
    var isHot = [Suggestion(advice:"turn your heating down before you go to bed",subgroup:16),
                  Suggestion(advice:"turn the radiator down in your room",subgroup:16)]
    var isCold = [Suggestion(advice:"turn your heating up before going to bed",subgroup:17),
                  Suggestion(advice:"set your heating time to come on after midnight",subgroup:17),
                  Suggestion(advice:"try turning the radiator on in your room before going to bed",subgroup:17)]
    var humidity = [Suggestion(advice:"your room is too humid, try a de-humidifier",subgroup:18)]
    
    // variables holding personal settings
    var exerciseLevel = 0       // 0 = no exercise, 1 = small amount of exercise, 2 = regular exercise
    var drinksCoffee = 1        // binary: 0 = false, 1 = true
    var isSmoker = 0            // binary: 0 = false, 1 = true
    var isTooHot = 0               // binary: 0 = false, 1 = true
    var deviceEffect = 0        // 0 = minor effect, 1 = major effect
    
    // variables to keep track of repeated suggestions
    var currentValue = 0
    var previousValue = 0
    var count = 0
    var removalArray = [Int]()
    
    // takes as input the advice group and returns advice as a string
    func getSuggestion(group: String) -> String{
        var advice: String
        switch group{
        case "duration":
            if duration.isEmpty{
                return "empty advice"
            }
            advice = getDurationAdvice()
        case "exercise":
            if exercise.isEmpty{
                return "empty advice"
            }
            advice = getExerciseAdvice()
        case "caffeine":
            if caffeine.isEmpty{
                return "empty advice"
            }
            advice = getCaffeineAdvice()
        case "meal":
            if meal.isEmpty{
                return "empty advice"
            }
            advice = getMealAdvice()
        case "alcohol":
            if alcohol.isEmpty{
                return "empty advice"
            }
            advice = getAlcoholAdvice()
        case "light":
            if light.isEmpty{
                return "empty advice"
            }
            advice = getLightAdvice()
        case "heat":
            if isHot.isEmpty{
                return "empty advice"
            }
            advice = getIsHotAdvice()
        case "cold":
            if isCold.isEmpty{
                return "empty advice"
            }
            advice = getIsColdAdvice()
        case "humidity":
            if humidity.isEmpty{
                return "empty advice"
            }
            advice = getHumidityAdvice()
        default:
            return "empty advice"
        }
        if currentValue != previousValue{
            count = 1
        }
        else if count > 2{
            return "empty advice"
        }
        else{
            count = count + 1
            previousValue = currentValue
        }
        return advice
    }
    
    // returns advice for duration group
    func getDurationAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(duration.count))
        currentValue = duration[Int(n)].subgroup
        return String(describing:duration[Int(n)].advice)
    }
    // returns advice for exercise group
    func getExerciseAdvice() -> String{
        var n:UInt32
        if (exerciseLevel == 0 && exercise.count > 4){
            n = arc4random_uniform(1) + 4
        }
        else if (exerciseLevel == 1 && exercise.count > 3){
            n = arc4random_uniform(3) + 1
        }
        else if exerciseLevel == 2{
            n = arc4random_uniform(1)
        }
        else{
            return "empty advice"
        }
        currentValue = exercise[Int(n)].subgroup
        return String(describing:exercise[Int(n)].advice)
    }
    // returns advice for caffeine group
    func getCaffeineAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(caffeine.count))
        currentValue = caffeine[Int(n)].subgroup
        return String(describing:caffeine[Int(n)].advice)
    }
    // returns advice for meal group
    func getMealAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(meal.count))
        currentValue = meal[Int(n)].subgroup
        return String(describing:meal[Int(n)].advice)
    }
    // returns advice for alcohol group
    func getAlcoholAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(alcohol.count))
        currentValue = alcohol[Int(n)].subgroup
        return String(describing:alcohol[Int(n)].advice)
    }
    // returns advice for light group
    func getLightAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(light.count))
        currentValue = light[Int(n)].subgroup
        return String(describing:light[Int(n)].advice)
    }
    // returns advice for isHot group
    func getIsHotAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(isHot.count))
        currentValue = isHot[Int(n)].subgroup
        return String(describing:isHot[Int(n)].advice)
    }
    // returns advice for isCold group
    func getIsColdAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(isCold.count))
        currentValue = isCold[Int(n)].subgroup
        return String(describing:isCold[Int(n)].advice)
    }
    // returns advice for humidity group
    func getHumidityAdvice() -> String{
        let n:UInt32 = arc4random_uniform(UInt32(humidity.count))
        currentValue = humidity[Int(n)].subgroup
        return String(describing:humidity[Int(n)].advice)
    }
    
    // removes advice of the same subgroup that have been rejected by the user
    func removeSuggestion(){
        if currentValue == 1{
            for i in 0...1{
                if duration[i].subgroup == currentValue{
                    removalArray.append(i)
                }
            }
            for _ in removalArray{
                let a = removalArray.removeLast()
                duration.remove(at: a)
            }
            removalArray = []
        }
        else if (currentValue == 2 || currentValue == 3 || currentValue == 4){
            for i in 0...4{
                if exercise[i].subgroup == currentValue{
                    removalArray.append(i)
                }
            }
            for _ in removalArray{
                let a = removalArray.removeLast()
                exercise.remove(at: a)
            }
            removalArray = []
        }
        else if currentValue == 5{
            for i in 0...1{
                if caffeine[i].subgroup == currentValue{
                    removalArray.append(i)
                }
            }
            for _ in removalArray{
                let a = removalArray.removeLast()
                caffeine.remove(at: a)
            }
            removalArray = []
        }
        else if (currentValue == 6 || currentValue == 7){
            for i in 0...4{
                if meal[i].subgroup == currentValue{
                    removalArray.append(i)
                }
            }
            for _ in removalArray{
                let a = removalArray.removeLast()
                meal.remove(at: a)
            }
            removalArray = []
        }
        else if currentValue == 9{
            alcohol.remove(at: 1)
            alcohol.remove(at: 0)
        }
        else if currentValue == 14{
            light.remove(at: 1)
            light.remove(at: 0)
        }
        else if currentValue == 16{
            isHot.remove(at: 1)
            isHot.remove(at: 0)
        }
        else if currentValue == 17{
            isCold.remove(at: 2)
            isCold.remove(at: 1)
            isCold.remove(at: 0)
        }
        else if currentValue == 18{
            humidity.remove(at: 0)
        }
    }
}
