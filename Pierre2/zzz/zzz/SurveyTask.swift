//
//  SurveyTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Before going to bed"
    instructionStep.text = "Please answer the following questions: they will help us incorporate your lifestyle habits into the sleep analysis results."
    steps += [instructionStep]
    
    //Name question
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    
    steps += [nameQuestionStep]
    
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
    let devicesAnswerFormat = ORKBooleanAnswerFormat()
    let devicesQuestionStepTitle = "Do you leave electronic devices turned on in your bedroom at night?"
    let devicesQuestionStep = ORKQuestionStep(identifier: "DevicesQuestionStep", title: devicesQuestionStepTitle, answer: devicesAnswerFormat)
    
    steps += [devicesQuestionStep]
    
    // Do you feel tired tonight?
    let tiredAnswerFormat = ORKBooleanAnswerFormat()
    let tiredQuestionStepTitle = "Do you feel tired tonight?"
    let tiredQuestionStep = ORKQuestionStep(identifier: "TiredQuestionStep", title: tiredQuestionStepTitle, answer: tiredAnswerFormat)
    
    steps += [tiredQuestionStep]
   
//    //'what is your quest' question
//    let questQuestionStepTitle = "What is your quest?"
//    let textChoices = [
//        ORKTextChoice(text: "Create a ResearchKit App", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
//        ORKTextChoice(text: "Seek the Holy Grail", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
//        ORKTextChoice(text: "Find a shrubbery", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
//    ]
//    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
//    steps += [questQuestionStep]
//    
//    //Color question step
//    let colorQuestionStepTitle = "What is your favorite color?"
//    let colorTuples = [
//        (UIImage(named: "red")!, "Red"),
//        (UIImage(named: "orange")!, "Orange"),
//        (UIImage(named: "yellow")!, "Yellow"),
//        (UIImage(named: "green")!, "Green"),
//        (UIImage(named: "blue")!, "Blue"),
//        (UIImage(named: "purple")!, "Purple")
//    ]
//    let imageChoices : [ORKImageChoice] = colorTuples.map {
//        return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
//    }
//    let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
//    let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
//    steps += [colorQuestionStep]
    
    //Summary 
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Time to go to bed!"
    summaryStep.text = "Sleep well :)"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "BeforeBedSurveyTask", steps: steps)
}
