//
//  BedtimeTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

public var BedtimeTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    // ***** BEFORE BEDTIME SURVEY ********************************************************************
    
    //Instructions step
    let bedoreBedIntroStep = ORKInstructionStep(identifier: "BeforeBedIntroStep")
    bedoreBedIntroStep.title = "Before going to bed"
    bedoreBedIntroStep.text = "Please answer the following questions: they will help us incorporate your lifestyle habits into the sleep analysis results."
    steps += [bedoreBedIntroStep]
    
    // Did you exercise today?
    let exerciseAnswerFormat = ORKBooleanAnswerFormat()
    let exerciseQuestionStepTitle = "Did you exercise today?"
    let exerciseQuestionStep = ORKQuestionStep(identifier: "ExerciseQuestionStep", title: exerciseQuestionStepTitle, answer: exerciseAnswerFormat)
    
    steps += [exerciseQuestionStep]
    
    // When did you have dinner?
    let dinnerTimeChoices : [ORKTextChoice] = [ORKTextChoice(text: "30 mins ago", value: Float(0.5) as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "1 hour ago", value: Float(1) as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "2 hours ago", value: Float(2) as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "3 hours ago", value: Float(3) as NSCoding & NSCopying & NSObjectProtocol)]
    
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
    
    // Before bedtie survey summary
    let beforeBedSummaryStep = ORKCompletionStep(identifier: "BeforeBedSummaryStep")
    beforeBedSummaryStep.title = "Time to go to bed!"
    beforeBedSummaryStep.text = "Sleep well :)"
    steps += [beforeBedSummaryStep]
    
    // ***** NIGHT MONITORING USING SENSORTAG ********************************************************
    
    // Instruction step
    let sensorInstructionStep = ORKInstructionStep(identifier: "SensorInstructionStep")
    sensorInstructionStep.title = "Sensor setup"
    sensorInstructionStep.text = "Please turn on the SensorTag in order to connect it to your smartphone, and place it on your bed, with the openings facing the ceiling"
//    sensorInstructionStep.detailText = "The device will monitor temperature, humidity, light and movement while you sleep"
    sensorInstructionStep.image = #imageLiteral(resourceName: "sensortag")
    steps += [sensorInstructionStep]
    
    // Recording step
    let sensorRecordingStep = SensorActiveStep(identifier: "SensorRecordingStep")
    sensorRecordingStep.title = "Night monitoring"
    sensorRecordingStep.text = "You can now put your phone away. Click next in the morning to complete the recording."
    //sensorRecordingStep.stepDuration
    steps += [sensorRecordingStep]
    
    // ***** AFTER BEDTIME SURVEY ********************************************************************
    
    //Instructions step
    let afterBedIntroStep = ORKInstructionStep(identifier: "AfterBedIntroStep")
    afterBedIntroStep.title = "Good morning!"
    afterBedIntroStep.text = "Please answer the following questions: they will help us understand how well you slept and what affects you in the morning."
    steps += [afterBedIntroStep]
    
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
    
    // Summary
    let afterBedSummaryStep = ORKCompletionStep(identifier: "AfterBedSummaryStep")
    afterBedSummaryStep.title = "All done!"
    afterBedSummaryStep.text = "Have a great day :)"
    steps += [afterBedSummaryStep]
    
    return ORKOrderedTask(identifier: "BedtimeTask", steps: steps)
}
