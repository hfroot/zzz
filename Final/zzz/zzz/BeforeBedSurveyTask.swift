//
//  BeforeBedSurveyTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

public var BeforeBedSurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Instructions step
    let instructionStep = ORKInstructionStep(identifier: "BeforeBedIntroStep")
    instructionStep.title = "Before going to bed"
    instructionStep.text = "Please answer the following questions: they will help us incorporate your lifestyle habits into the sleep analysis results."
    steps += [instructionStep]
    
    // Did you exercise today?
    let exerciseAnswerFormat = ORKBooleanAnswerFormat()
    let exerciseQuestionStepTitle = "Did you exercise today?"
    let exerciseQuestionStep = ORKQuestionStep(identifier: "ExerciseQuestionStep", title: exerciseQuestionStepTitle, answer: exerciseAnswerFormat)
    
    steps += [exerciseQuestionStep]
    
    // When did you have dinner?
    let dinnerTimeChoices : [ORKTextChoice] = [ORKTextChoice(text: "30 mins ago", value: 0.5 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "1 hour ago", value: 1 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "2 hours ago", value: 2 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "3 hours ago", value: 3 as NSCoding & NSCopying & NSObjectProtocol)]
    
    let dinnerAnswerFormat = ORKAnswerFormat.textScale(with: dinnerTimeChoices, defaultIndex: NSIntegerMax, vertical: true)
    let dinnerQuestionStepTitle = "When did you have dinner?"
    let dinnerQuestionStep = ORKQuestionStep(identifier: "DinnerQuestionStep", title: dinnerQuestionStepTitle, answer: dinnerAnswerFormat)

    
    steps += [dinnerQuestionStep]
    
    // Did you have any kind of sexual intercourse today?
    let sexAnswerFormat = ORKBooleanAnswerFormat()
    let sexQuestionStepTitle = "Have you had any kind of sexual intercourse today?"
    let sexQuestionStep = ORKQuestionStep(identifier: "SexQuestionStep", title: sexQuestionStepTitle, answer: sexAnswerFormat)
    
    steps += [sexQuestionStep]
    
    // In the last 5 hours did you consome alcohol/tobacco/coffee?
    let stimulantChoiceOneText = NSLocalizedString("Drink alcohol", comment: "")
    let stimulantChoiceTwoText = NSLocalizedString("Smoke", comment: "")
    let stimulantChoiceThreeText = NSLocalizedString("Drink coffee", comment: "")
    let stimulantChoices = [
        ORKTextChoice(text: stimulantChoiceOneText, value: "alcohol" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: stimulantChoiceTwoText, value: "tobacco" as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: stimulantChoiceThreeText, value: "coffee" as NSCoding & NSCopying & NSObjectProtocol)]
    let stimulantAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: stimulantChoices)
    let stimulantQuestionStep = ORKQuestionStep(identifier: "StimulantsQuestionStep", title: "In the last 5 hours did you:", answer: stimulantAnswerFormat)
    stimulantQuestionStep.text = "Select all that apply"
    
    steps += [stimulantQuestionStep]
    
    // Do you sleep naked?
    let nakedAnswerFormat = ORKBooleanAnswerFormat()
    let nakedQuestionStepTitle = "Do you sleep naked?"
    let nakedQuestionStep = ORKQuestionStep(identifier: "NakedQuestionStep", title: nakedQuestionStepTitle, answer: nakedAnswerFormat)
    
    steps += [nakedQuestionStep]
    
    // Did you drink water in the last hour?
    let waterAnswerFormat = ORKBooleanAnswerFormat()
    let waterQuestionStepTitle = "Did you drink water in the last hour?"
    let waterQuestionStep = ORKQuestionStep(identifier: "WaterQuestionStep", title: waterQuestionStepTitle, answer: waterAnswerFormat)
    
    steps += [waterQuestionStep]
    
    // Do you leave electronic devices turned on in your bedroom at night?
    let nightDeviceAnswerFormat = ORKBooleanAnswerFormat()
    let nightDeviceQuestionStepTitle = "Do you leave electronic devices turned on in your bedroom at night?"
    let nightDeviceQuestionStep = ORKQuestionStep(identifier: "NightDeviceQuestionStep", title: nightDeviceQuestionStepTitle, answer: nightDeviceAnswerFormat)
    
    steps += [nightDeviceQuestionStep]
    
    // Do you feel tired tonight?
    let nightTiredAnswerFormat = ORKBooleanAnswerFormat()
    let nightTiredQuestionStepTitle = "Do you feel tired tonight?"
    let nightTiredQuestionStep = ORKQuestionStep(identifier: "NightTiredQuestionStep", title: nightTiredQuestionStepTitle, answer: nightTiredAnswerFormat)
    
    steps += [nightTiredQuestionStep]
    
    // Summary 
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Time to go to bed!"
    summaryStep.text = "Sleep well :)"
    steps += [summaryStep]
    
    // Custom task for sensortag data recording
    // Insert code here...
    
    return ORKOrderedTask(identifier: "BeforeBedSurveyTask", steps: steps)
}
