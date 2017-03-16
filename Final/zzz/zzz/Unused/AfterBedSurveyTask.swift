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
    let wakeLightChoiceOneText = NSLocalizedString("No light", comment: "")
    let wakeLightChoiceTwoText = NSLocalizedString("Artificial light", comment: "")
    let wakeLightChoiceThreeText = NSLocalizedString("Natural light", comment: "")
    let wakeLightChoices = [
        ORKTextChoice(text: wakeLightChoiceOneText, value: "none" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: wakeLightChoiceTwoText, value: "artificial" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: wakeLightChoiceThreeText, value: "natural" as NSCoding & NSCopying & NSObjectProtocol)]
    let wakeLightAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: wakeLightChoices)
    let wakeLightQuestionStep = ORKQuestionStep(identifier: "WakeLightQuestionStep", title: "Did you wake up to:", answer: wakeLightAnswerFormat)
    
    steps += [wakeLightQuestionStep]
    
    // Did you wake up to use the toilet during the night?
    let toiletAnswerFormat = ORKBooleanAnswerFormat()
    let toiletQuestionStepTitle = "Did you wake up to use the toilet during the night?"
    let toiletQuestionStep = ORKQuestionStep(identifier: "ToiletQuestionStep", title: toiletQuestionStepTitle, answer: toiletAnswerFormat)
    
    steps += [toiletQuestionStep]
    
    // Did you turn the light on during the night?
    let nightLightAnswerFormat = ORKBooleanAnswerFormat()
    let nightLightQuestionStepTitle = "Did you turn the light on during the night?"
    let nightLightQuestionStep = ORKQuestionStep(identifier: "NightLightQuestionStep", title: nightLightQuestionStepTitle, answer: nightLightAnswerFormat)
    
    steps += [nightLightQuestionStep]
    
    // Did any electronic device wake you up during the night?
    let wakeDeviceAnswerFormat = ORKBooleanAnswerFormat()
    let wakeDeviceQuestionStepTitle = "Did any electronic device wake you up during the night?"
    let wakeDeviceQuestionStep = ORKQuestionStep(identifier: "WakeDeviceQuestionStep", title: wakeDeviceQuestionStepTitle, answer: wakeDeviceAnswerFormat)
    
    steps += [wakeDeviceQuestionStep]
    
    // Do you feel tired this morning?
    let wakeTiredAnswerFormat = ORKBooleanAnswerFormat()
    let wakeTiredQuestionStepTitle = "Do you feel tired this morning?"
    let wakeTiredQuestionStep = ORKQuestionStep(identifier: "WakeTiredQuestionStep", title: wakeTiredQuestionStepTitle, answer: wakeTiredAnswerFormat)
    
    steps += [wakeTiredQuestionStep]
    
    // Do you feel like you slept well overall?
    let wakeSleepAnswerFormat = ORKBooleanAnswerFormat()
    let wakeSleepQuestionStepTitle = "Do you feel like you slept well overall?"
    let wakeSleepQuestionStep = ORKQuestionStep(identifier: "WakeSleepQuestionStep", title: wakeSleepQuestionStepTitle, answer: wakeSleepAnswerFormat)
    
    steps += [wakeSleepQuestionStep]
    
    return ORKOrderedTask(identifier: "AfterBedSurveyTask", steps: steps)
    
}
