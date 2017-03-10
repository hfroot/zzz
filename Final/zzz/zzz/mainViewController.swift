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

class mainViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension mainViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            
            if let registrationData = taskViewController.result.stepResult(forStepIdentifier: "RegisterStep") {
                
                let registrationEmail = (((registrationData as ORKStepResult).result(forIdentifier: "ORKRegistrationFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(registrationEmail)'")
                
                if userLookup.isEmpty {
                    registerAccount(registrationData: registrationData as ORKStepResult)
                    
                    let alertTitle = NSLocalizedString("Registration successful", comment: "")
                    let alertMessage = NSLocalizedString("Please login to use the ZZZ app", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alertTitle = NSLocalizedString("Registration failed", comment: "")
                    let alertMessage = NSLocalizedString("User with this email already exists", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                
            } 
            
            if let loginData = taskViewController.result.stepResult(forStepIdentifier: "LoginStep") {
                
                let loginEmail = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                let loginPassword = (((loginData as ORKStepResult).result(forIdentifier: "ORKLoginFormItemPassword") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
                
                let userLookup = realm.objects(User.self).filter("email = '\(loginEmail)'")
                
                if userLookup.isEmpty {
                    let alertTitle = NSLocalizedString("Login failed", comment: "")
                    let alertMessage = NSLocalizedString("User not registered: please register an account first", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    if loginPassword != userLookup[0].password {
                        let alertTitle = NSLocalizedString("Login failed", comment: "")
                        let alertMessage = NSLocalizedString("Incorrect password", comment: "")
                        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        currentUser = userLookup[0]
                        print("Successfully logged in \(currentUser.firstName)")
                        // make transition to 'logged in' menu
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
    
}
