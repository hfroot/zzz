//
//  increment.swift
//  
//
//  Created by user125883 on 3/13/17.
//
//

import Foundation


func adjustWeight(classifier: String, result: Int) -> Bool{
    switch classifier{
    case "temperature":
        switch result{
        case 0:
            decrementWeight(factor: "heat")
            decrementWeight(factor: "cold")
            return true
        case 1:
            // temperature is too high
            incrementWeight(factor: "heat")
            setToZero(factor: "cold")
            return true
        case 2:
            // temperature is too low
            incrementWeight(factor: "cold")
            setToZero(factor: "heat")
            return true
        default:
            return false
        }
    case "humidity":
        switch result{
        case 0:
            decrementWeight(factor: "humidity")
            return true
        case 1:
            // humidity is too high
            incrementWeight(factor: "humidity")
            return true
        case 2:
            // not implemented yet
            return true
        default:
            return false
        }
    case "light":
        switch result{
        case 0:
            decrementWeight(factor: "light")
            return true
        case 1:
            incrementWeight(factor: "light")
            return true
        default:
            return false
        }
    default:
        return false
    }
}

func incrementWeight(factor: String){
    // NOTE: remove default once reading from the db
    var defaultWeight = 0.5
    var currentWeight = 0.0
    var newWeight = 0.0
    
    switch factor{
    case "heat":
        // TODO: read heat weight from db
        currentWeight = defaultWeight
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
        // TODO: write newWeight to db
    case "cold":
        // TODO: read cold weight from db
        currentWeight = defaultWeight
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
        // TODO: write newWeight to db
    case "humidity":
        // TODO: read humidity weight from db
        currentWeight = defaultWeight
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
    // TODO: write newWeight to db
    case "light":
        // TODO: read light weight from db
        currentWeight = defaultWeight
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
        // TODO: write newWeight to db
    default:
        ()
    }
}

func decrementWeight(factor: String){
    switch factor{
    case "heat":
        // TODO: read heat weight
        // TODO: write new heat weight
        print("decrementing heat")
    case "cold":
        // TODO: read cold weight
        // TODO: write new cold weight
        print("decrementing cold")
    case "humidity":
        // TODO: read humidity weight
        // TODO: write new humidity weight
        print("decrementing humidity")
    case "light":
        // TODO: read light weight
        // TODO: write new light weight
        print("decrementing light")
    default:
        ()
    }
}

func setToZero(factor: String){
    switch factor{
    case "heat":
        // TODO: write weight to 0
        print("heat to 0")
    case "cold":
        // TODO: write weight to 0
        print("cold to 0")
    case "humidity":
        // TODO: write weight to 0
        print("humidity to 0")
    case "light":
        // TODO: write weight to 0
        print("light to 0")
    default:
        ()
    }
}
