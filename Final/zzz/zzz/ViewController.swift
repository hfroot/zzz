//
//  ViewController.swift
//  zzz
//
//  Created by Pierre Azalbert on 07/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    
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
    
    @IBAction func registerTapped(sender : AnyObject) {
        let registerTaskViewController = ORKTaskViewController(task: RegistrationTask, taskRun: nil)
        registerTaskViewController.delegate = self
        present(registerTaskViewController, animated: true, completion: nil)
    }
    
    @IBAction func chartsTapped(sender : AnyObject) {
        let chartsViewController = ChartListViewController()
        present(chartsViewController, animated: true, completion: nil)
    }
    
    @IBAction func schedulerTapped(_ sender: AnyObject) {
        let sleepSchedulerListViewController = SleepSchedulerListViewController()
        present(sleepSchedulerListViewController, animated: true, completion: nil)
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

extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
            case .completed:
                
                let results = taskViewController.result.results as! [ORKStepResult]
                
                for step in results {
                    let stepResult = step.results as! [ORKQuestionResult]
                    for item in stepResult {
                        if let question = item as? ORKBooleanQuestionResult {
                            print(question.identifier)
                            if question.booleanAnswer != nil {
                                let answer = question.booleanAnswer!
                                if answer == 0 {print("No")}
                                if answer == 1 {print("Yes")}
                            }
                            else {
                                let answer = "Skipped"
                                print(answer)
                            }
                            
                            
                        }
                        else if let question = item as? ORKChoiceQuestionResult {
                            print(question.identifier)
                            if question.choiceAnswers != nil {
                                let answers = question.choiceAnswers!
                                if answers.count == 1 {
                                    let answer = answers[0]
                                    print(answer)
                                }
                                else {
                                    let answer = answers
                                    print(answer)
                                }
                            }
                            else {
                                let answer = "Skipped"
                                print(answer)
                            }
                        }

                    }
                }
                
//                let result = taskViewController.result.result(forIdentifier: "WaterQuestionStep")!
//                print(result, "\n")
//                let result_unpacked = result as! ORKStepResult
//                print(result_unpacked, "\n")
//                let result_unpacked_unpacked = result_unpacked.results!
//                print(result_unpacked_unpacked, "\n")
//                let answer = result_unpacked_unpacked as? ORKBooleanQuestionResult
//                print(answer?.answer)
                
//                let taskResults = taskViewController.result.results
//                
//                for items in taskResults! {
//                    let result = items as! ORKStepResult
//                    let id = result.identifier
//                    let content = result.results!
//
//                    
//                    //let data = UnsafePointer<UInt>(items)
//                }
                
//                let taskResult = taskViewController.result
//                let jsonData = try! ORKESerializer.jsonData(for: taskResult)
//                
//                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
//                    //print(jsonString)
//                    let data = convertToDictionary(text: jsonString as String)
//                    let results = data!["results"]
//                    let steps = convertToDictionary(text: results! as String)
//                    print(steps)
//                }

                break
            case .failed, .discarded, .saved: break
        }
        
        
        
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }

    
}
