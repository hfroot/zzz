//
//  SVM.swift
//  zzz
//
//  Created by Xavier Laguarta Soler on 15/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import AIToolbox

func humidClassifier(humid_mean: Float, humid_max: Float) -> Int {
    var result = 3
    let data = DataSet(dataType: .realAndClass, inputDimension: 2, outputDimension: 1)
    do {
        try data.addDataPoint(input: [40.5, 44.5], dataClass:1)
        try data.addDataPoint(input: [41.3,45.7], dataClass:1)
        try data.addDataPoint(input: [39, 43.5], dataClass:1)
        try data.addDataPoint(input: [39.5,44], dataClass:1)
        try data.addDataPoint(input: [38.6, 41.3], dataClass:0)
        try data.addDataPoint(input: [38, 41.2], dataClass:0)
        try data.addDataPoint(input: [35,38], dataClass:2)
        try data.addDataPoint(input: [36, 38.3], dataClass:2)
        try data.addDataPoint(input: [35.2, 38.9], dataClass:2)
    }
    catch {
        print("Invalid data set created")
    }
    
    let svm = SVMModel(problemType: .c_SVM_Classification, kernelSettings:
        KernelParameters(type: .radialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
    
    do {
        try svm.trainClassifier(data)
    }
    catch {
        print("SVM Training error")
    }
    
    do {
        let result = try svm.classifyOne([Double(humid_mean), Double(humid_max)])
        return(result)
    }
    catch {
        print("Error having SVM calculate result")
    }
    
}
