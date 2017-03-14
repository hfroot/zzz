//
//  increment.swift
//  
//
//  Created by user125883 on 3/13/17.
//
//

import Foundation


func adjustWeight(classifier: String, result: Int) {
    switch classifier{
    case "temperature":
        // TODO: read current temperature weights
        var hotWeight = 0.5
        var coldWeight = 0.5
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
        // TODO: write new temperature weights
    case "humidity":
        // TODO: read current humidity weight
        var humidityWeight = 0.5
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
        // TODO: write new humidity weight
    case "light":
        // TODO: read current light weight
        var lightWeight = 0.5
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
        // TODO: write new light weight
    default:
        ()
    }
}

func incrementWeight(currentWeight: Double) -> Double{
    var newWeight = 0.0
    if ((currentWeight >= 0 && currentWeight < 0.1) || (currentWeight >= 0.925 && currentWeight < 1)){
        newWeight = currentWeight + 0.025
    }
    else if ((currentWeight >= 0.1 && currentWeight < 0.225) || (currentWeight >= 0.8 && currentWeight < 0.925)){
        newWeight = currentWeight + 0.05
    }
    else if ((currentWeight >= 0.225 && currentWeight < 0.325) || (currentWeight >= 0.7 && currentWeight < 0.8)){
        newWeight = currentWeight + 0.075
    }
    else if ((currentWeight >= 0.325 && currentWeight < 0.4) || (currentWeight >= 0.625 && currentWeight < 0.7)){
        newWeight = currentWeight + 0.1
    }
    else if ((currentWeight >= 0.4 && currentWeight < 0.625)){
        newWeight = currentWeight + 0.125
    }
    else if (currentWeight < 0){
        newWeight = 0
    }
    else if (currentWeight > 1){
        newWeight = 1
    }
    return newWeight
}

func decrementWeight(currentWeight: Double) -> Double{
    return currentWeight - 0.1
}
