//
//  SVM.swift
//  zzz
//
//  Created by Pierre Azalbert on 12/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import Foundation
import AIToolbox

func testClassification() {
    //  Create a data set
    let data = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
    do {
        try data.addDataPoint(input: [26.0, 28.0], output:1)
        try data.addDataPoint(input: [27.0, 29.9], output:1)
        try data.addDataPoint(input: [26.5, 28.0], output:1)
        try data.addDataPoint(input: [26.3, 28.0], output:1)
        try data.addDataPoint(input: [25.0, 27.1], output:0)
        try data.addDataPoint(input: [24.9, 27.2], output:0)
        try data.addDataPoint(input: [24.5, 27.2], output:0)
        try data.addDataPoint(input: [23.9, 26.9], output:0)
        try data.addDataPoint(input: [20.5, 1.0], output:2)
        try data.addDataPoint(input: [19.0, 21.0], output:2)
        try data.addDataPoint(input: [19.0, 22.1], output:2)
        try data.addDataPoint(input: [18.9, 21.0], output:2)
    }
    catch {
        print("Invalid data set created")
    }
    
    //  Create an SVM classifier and train
    let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
        KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
    svm.train(data)
    
    //  Create a test dataset
    let testData = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
    do {
        let result = try testData.addTestDataPoint(input: [18.0, 19.1])    //  Expect 1
        print(testData)
        print(result)
        
    }
    catch {
        print("Invalid data set created")
    }
    
    //  Predict on the test data
    svm.predictValues(testData)
    
    //  See if we matched
    var classLabel : Int
    do {
        try classLabel = testData.getClass(0)
        XCTAssert(classLabel == 1, "first test data point, expect 1")
            }
    catch {
        print("Error in prediction")
    }
}
