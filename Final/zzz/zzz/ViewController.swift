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

class ViewController: UIViewController {
    
    @IBAction func registerTapped(sender : AnyObject) {
        let registerTaskViewController = ORKTaskViewController(task: RegistrationTask, taskRun: nil)
        registerTaskViewController.delegate = self
        present(registerTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(sender : AnyObject) {
        let loginTaskViewController = ORKTaskViewController(task: LoginTask, taskRun: nil)
        loginTaskViewController.delegate = self
        present(loginTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func consentTapped(sender : AnyObject) {
        let consentTaskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        consentTaskViewController.delegate = self
        present(consentTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func beforeBedSurveyTapped(sender : AnyObject) {
        let beforeBedTaskViewController = ORKTaskViewController(task: BeforeBedSurveyTask, taskRun: nil)
        beforeBedTaskViewController.delegate = self
        present(beforeBedTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func afterBedSurveyTapped(sender : AnyObject) {
        let afterBedTaskViewController = ORKTaskViewController(task: AfterBedSurveyTask, taskRun: nil)
        afterBedTaskViewController.delegate = self
        present(afterBedTaskViewController, animated: true, completion: nil)
    }

    @IBAction func chartsTapped(sender : AnyObject) {
        present(ChartListViewController(), animated: true, completion: nil)
    }
    
//    @IBAction func sensorTapped(sender : AnyObject) {
//        present(SensorViewController(), animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            if let registrationData = taskViewController.result.stepResult(forStepIdentifier: "RegisterStep") {
                
                let registrationEmail = (((registrationData as ORKStepResult).result(forIdentifier: "ORKRegistrationFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(registrationEmail)'")
                
                if userLookup.isEmpty {
                    registerAccount(registrationData: registrationData as ORKStepResult)
                    print("Successfully created account for \(currentUser.firstName)")
                }
                else {
                    print("Registration failed: user with this email already exists!")
                }

                
            } 
            
            if let loginData = taskViewController.result.stepResult(forStepIdentifier: "LoginStep") {
                
                let loginEmail = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                let loginPassword = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemPassword") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(loginEmail)'")
                
                if userLookup.isEmpty {
                    print("Login failed: user not registered! Please register an account first.")
                }
                else {
                    if loginPassword != userLookup[0].password {
                        print("Login failed: incorrect password!")
                    }
                    else {
                        currentUser = userLookup[0]
                        print("Successfully logged in \(currentUser.firstName)")
                    }
                    
                }
            }


            
            
        case .failed, .discarded, .saved: break
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
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Realm Functions
    
//    func saveSample(){
//        try! realm.write {
//            let newData = sensorDataObject(value: ["sensorID": sensorTag!.identifier.uuidString,
//                                                       "sensorTemp": sampleTemp!,
//                                                       "sensorHumi": sampleHumi!,
//                                                       "sensorTimestamp": sampleTimestamp!,
//                                                       "sensorLight":sampleLight!,
//                                                       "sensorAccX":sampleAccX!,
//                                                       "sensorAccY":sampleAccY!,
//                                                       "sensorAccZ":sampleAccZ!])
//            
//                currentUser.surveyData.append(newData)
//                realm.add(currentUser, update: true)
//                print("Added object to database: \(newData)")
//        }
//    }
    
}
