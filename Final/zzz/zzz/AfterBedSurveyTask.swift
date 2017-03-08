//
//  AfterBedSurveyTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 08/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

public var AfterBedSurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Instructions step
    let instructionStep = ORKInstructionStep(identifier: "AfterBedIntroStep")
    instructionStep.title = "Good morning!"
    instructionStep.text = "Please answer the following questions: they will help us understand how well you slept and what affects you in the morning."
    steps += [instructionStep]
    
    // Did you wake up to dark room/artificial/natural light?
    let lightChoiceOneText = NSLocalizedString("No light", comment: "")
    let lightChoiceTwoText = NSLocalizedString("Artificial light", comment: "")
    let lightChoiceThreeText = NSLocalizedString("Natural light", comment: "")
    let lightChoices = [
        ORKTextChoice(text: lightChoiceOneText, value: "none" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: lightChoiceTwoText, value: "artificial" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: lightChoiceThreeText, value: "natural" as NSCoding & NSCopying & NSObjectProtocol)]
    let lightAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: lightChoices)
    let lightQuestionStep = ORKQuestionStep(identifier: "LightQuestionStep", title: "Did you wake up to:", answer: lightAnswerFormat)
    
    steps += [lightQuestionStep]
    
    return ORKOrderedTask(identifier: "AfterBedSurveyTask", steps: steps)
}
