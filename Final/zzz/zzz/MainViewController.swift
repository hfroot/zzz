//
//  ViewController.swift
//  zzz
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import UIKit
import ResearchKit
import RealmSwift

class MainViewController: UIViewController {
    
    var loggedIn:Bool = false
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var bedtimeButton: UIButton!
    @IBOutlet var lastNightButton: UIButton!
    @IBOutlet var trendsButton: UIButton!
    @IBOutlet var networkButton: UIButton!
    @IBOutlet var trainingButton: UIButton!
    @IBOutlet var adviceButton: UIButton!
    
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBAction func registerTapped(sender : UIButton) {
        let registerTaskViewController = ORKTaskViewController(task: RegistrationTask, taskRun: nil)
        registerTaskViewController.delegate = self
        present(registerTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(sender : UIButton) {
        if loggedIn {
            loggedIn = false
            currentUser = User()
            updateUI()
        }
        else {
            let loginTaskViewController = ORKTaskViewController(task: LoginTask, taskRun: nil)
            loginTaskViewController.delegate = self
            present(loginTaskViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func bedtimeTapped(sender : UIButton) {
        //bedtimeButton.isEnabled = true
        let beforeBedTaskViewController = ORKTaskViewController(task: BedtimeTask, taskRun: nil)
        beforeBedTaskViewController.delegate = self
        present(beforeBedTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func chartsTapped(sender : UIButton) {
        present(ChartListViewController(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        if loggedIn {
            self.registerButton.isHidden = true
            self.welcomeLabel.text = "Welcome \(currentUser.firstName)"
            self.loginButton.setTitle("Logout", for: .normal)
            
            self.bedtimeButton.isHidden = false
            self.lastNightButton.isHidden = false
            self.trendsButton.isHidden = false
            self.networkButton.isHidden = false
            self.trainingButton.isHidden = false
            self.adviceButton.isHidden = false
            
        }
        else {
            self.registerButton.isHidden = false
            self.welcomeLabel.text = "Please login"
            self.loginButton.setTitle("Login", for: .normal)
            
            self.bedtimeButton.isHidden = true
            self.lastNightButton.isHidden = true
            self.trendsButton.isHidden = true
            self.networkButton.isHidden = true
            self.trainingButton.isHidden = true
            self.adviceButton.isHidden = true

        }
    }

}

extension MainViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            // Code to handle the registration form results
            
            if let registrationData = taskViewController.result.stepResult(forStepIdentifier: "RegisterStep") {
                
                let registrationEmail = (((registrationData as ORKStepResult).result(forIdentifier: "ORKRegistrationFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(registrationEmail)'")
                
                if userLookup.isEmpty {
                    registerAccount(registrationData: registrationData as ORKStepResult)
                    
                    let alertTitle = NSLocalizedString("Registration successful", comment: "")
                    let alertMessage = NSLocalizedString("Please login to use the ZZZ app", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    taskViewController.present(alert, animated: true, completion: nil)
                    taskViewController.dismiss(animated: true, completion: nil)
                }
                else {
                    let alertTitle = NSLocalizedString("Registration failed", comment: "")
                    let alertMessage = NSLocalizedString("User with this email already exists", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    taskViewController.present(alert, animated: true, completion: nil)
                }

            } 

            // Code to handle the login form results
            
            if let loginData = taskViewController.result.stepResult(forStepIdentifier: "LoginStep") {
                
                let loginEmail = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                let loginPassword = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemPassword") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(loginEmail)'")
                
                if userLookup.isEmpty {
                    let alertTitle = NSLocalizedString("Login failed", comment: "")
                    let alertMessage = NSLocalizedString("User not registered: please register an account first", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    taskViewController.present(alert, animated: true, completion: nil)
                }
                else {
                    if loginPassword != userLookup[0].password {
                        let alertTitle = NSLocalizedString("Login failed", comment: "")
                        let alertMessage = NSLocalizedString("Incorrect password", comment: "")
                        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                        taskViewController.present(alert, animated: true, completion: nil)
                    }
                    else {
                        currentUser = userLookup[0]
                        loggedIn = true
                        print("Successfully logged in \(currentUser.firstName)")
                        taskViewController.dismiss(animated: true, completion: nil)
                        updateUI()
                    }
                    
                }
            }
            
            // At the end of the before bed summary save survey answers to database
            
            if (taskViewController.result.stepResult(forStepIdentifier: "AfterBedSummaryStep") != nil) {
                
                // Bedtime answers
                var ExerciseQuestion:Bool?
                var DinnerQuestion:Float?
                var SexQuestion:Bool?
                var StimulantsQuestion:String?
                var NakedQuestion:Bool?
                var WaterQuestion:Bool?
                var NightDeviceQuestion:Bool?
                var NightTiredQuestion:Bool?
                
                // Morning answers
                var WakeLightQuestion:String?
                var ToiletQuestion:Bool?
                var NightLightQuestion:Bool?
                var WakeDeviceQuestion:Bool?
                var WakeTiredQuestion:Bool?
                var WakeSleepQuestion:Bool?
                
                if let bedtimeData = taskViewController.result.results as? [ORKStepResult] {
                    for stepResult: ORKStepResult in bedtimeData {
                        for result: ORKResult in stepResult.results! {
                            if let questionResult = result as? ORKBooleanQuestionResult {
                                if questionResult.booleanAnswer != nil {
                                    // Before bed questions
                                    if questionResult.identifier == "ExerciseQuestionStep" {
                                        ExerciseQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "SexQuestionStep" {
                                        SexQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "NakedQuestionStep" {
                                        NakedQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "WaterQuestionStep" {
                                        WaterQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "NightDeviceQuestionStep" {
                                        NightDeviceQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "NightTiredQuestionStep" {
                                        NightTiredQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    // After bed questions
                                    if questionResult.identifier == "ToiletQuestionStep" {
                                        ToiletQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "NightLightQuestionStep" {
                                        NightLightQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "WakeDeviceQuestionStep" {
                                        WakeDeviceQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "WakeTiredQuestionStep" {
                                        WakeTiredQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    if questionResult.identifier == "WakeSleepQuestionStep" {
                                        WakeSleepQuestion = questionResult.booleanAnswer! as Bool
                                    }
                                    
                                }
                            }
                            if let questionResult = result as? ORKChoiceQuestionResult {
                                if questionResult.choiceAnswers != nil {
                                    // Before bed questions
                                    if questionResult.identifier == "DinnerQuestionStep" {
                                        DinnerQuestion = questionResult.choiceAnswers![0] as? Float
                                    }
                                    if questionResult.identifier == "StimulantsQuestionStep" {
                                        StimulantsQuestion = String(describing: questionResult.choiceAnswers!)
                                    }
                                    // After bed questions
                                    if questionResult.identifier == "WakeLightQuestionStep" {
                                        WakeLightQuestion = questionResult.choiceAnswers![0] as? String
                                    }
                                }
                            }
                        }
                    }
                }
                
                let newBeforeBedData = beforeBedAnswersObject(value: ["ExerciseQuestion": ExerciseQuestion as Any,
                                                             "DinnerQuestion": DinnerQuestion as Any,
                                                             "SexQuestion": SexQuestion as Any,
                                                             "StimulantQuestion": StimulantsQuestion as Any,
                                                             "NakedQuestion": NakedQuestion as Any,
                                                             "WaterQuestion": WaterQuestion as Any,
                                                             "NightDeviceQuestion": NightDeviceQuestion as Any,
                                                             "NightTiredQuestion": NightTiredQuestion as Any])
                
                let newAfterBedData = afterBedAnswersObject(value: ["WakeLightQuestion": WakeLightQuestion as Any,
                                                            "ToiletQuestion": ToiletQuestion as Any,
                                                            "NightLightQuestion": NightLightQuestion as Any,
                                                            "WakeDeviceQuestion": WakeDeviceQuestion as Any,
                                                            "WakeTiredQuestion": WakeTiredQuestion as Any,
                                                            "WakeSleepQuestion": WakeSleepQuestion as Any])

                let newSensorData = currentSensorData
                
                let newSleepData = sleepDataObject(value: ["beforeBedAnswers": newBeforeBedData,
                                                           "afterBedAnswers": newAfterBedData,
                                                           "sensorData": newSensorData])
                
                saveSleepData(newSleepData: newSleepData)
                
            }

            // At the end of the after bed summary save survey asnwers to database
            // Also sync data with Realm Object Server accross devices
            // And process the collected data to produce classifiers and recommendations
            
            if (taskViewController.result.stepResult(forStepIdentifier: "AfterBedSummaryStep") != nil) {
                //testClassification()
                processData()
                taskViewController.dismiss(animated: true, completion: nil)
            }
            
            
        case .failed, .discarded, .saved:
            taskViewController.dismiss(animated: true, completion: nil)
        }
        
//        switch reason {
//            
//            // If survey was completed successfully, extract results before saving them on database
//            case .completed:
//                
//                let results = taskViewController.result.results as! [ORKStepResult]
//                //let resultsDict = [String:Any]
//                
//                for step in results {
//                    
//                    let stepResult = step.results as! [ORKQuestionResult]
//                    
//                    for item in stepResult {
//                        
//                        if let question = item as? ORKBooleanQuestionResult {
//                            
//                            print(question.identifier)
//                            
//                            if question.booleanAnswer != nil {
//                                let answer = question.booleanAnswer!
//                                if answer == 0 {print("no")}
//                                if answer == 1 {print("yes")}
//                            }
//                            else {
//                                let answer = "skipped"
//                                print(answer)
//                            }
//                        }
//                        else if let question = item as? ORKChoiceQuestionResult {
//                            
//                            print(question.identifier)
//                            
//                            if question.choiceAnswers != nil {
//                                
//                                let answers = question.choiceAnswers!
//                                
//                                if answers.count == 1 {
//                                    let answer = answers[0]
//                                    print(answer)
//                                }
//                                else {
//                                    let answer = answers
//                                    print(answer)
//                                }
//                            }
//                            else {
//                                let answer = "skipped"
//                                print(answer)
//                            }
//                        }
//
//                    }
//                }
//                
//                break
//            case .failed, .discarded, .saved: break
//        }
        
        //taskViewController.dismiss(animated: true, completion: nil)
    }
    
}