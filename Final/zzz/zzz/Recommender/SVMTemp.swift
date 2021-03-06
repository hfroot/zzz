//
//  SVM.swift
//  zzz
//
//  Created by Xavier Laguarta Soler on 15/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import AIToolbox

func tempClassifier(temp_mean: Float, temp_max: Float) -> Int {
    //var result = 3
    let data = DataSet(dataType: .realAndClass, inputDimension: 2, outputDimension: 1)
    do {
        try data.addDataPoint(input: [24.5, 25.5], dataClass:1)
        try data.addDataPoint(input: [24.3,25.7], dataClass:1)
        try data.addDataPoint(input: [23.9, 24.5], dataClass:1)
        try data.addDataPoint(input: [23,24], dataClass:0)
        try data.addDataPoint(input: [20.6, 21.3], dataClass:0)
        try data.addDataPoint(input: [18.6, 19.2], dataClass:0)
        try data.addDataPoint(input: [17,18], dataClass:2)
        try data.addDataPoint(input: [16.6, 17.3], dataClass:2)
        try data.addDataPoint(input: [16.2, 16.9], dataClass:2)
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
        let result = try svm.classifyOne([Double(temp_mean), Double(temp_max)])
        return(result)
    }
    catch {
        print("Error having SVM calculate result")
    }
    
}
