//
//  RegistrationTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 08/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

public var RegistrationTask: ORKTask {
    
    var steps = [ORKStep]()
    
    //Instructions step
    
    let registrationStepOptions: ORKRegistrationStepOption = [.includeGivenName, .includeFamilyName, .includeGender, .includeDOB]
    let registrationStep = ORKRegistrationStep(identifier: "RegisterStep",
                                               title: "Registration",
                                               text: "Please create an account to use the ZZZ app",
                                               options: registrationStepOptions)
    
    steps += [registrationStep]
    
    return ORKOrderedTask(identifier: "RegistrationTask", steps: steps)
}

//class RegisterViewController: UIViewController {
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let registerTaskViewController = ORKTaskViewController(task: RegistrationTask, taskRun: nil)
//        registerTaskViewController.delegate = self
//        present(registerTaskViewController, animated: true, completion: nil)
//
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//}
//
//extension RegisterViewController : ORKTaskViewControllerDelegate {
//    
//    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason:ORKTaskViewControllerFinishReason, error: Error?) {
//        
//        taskViewController.dismiss(animated: true, completion: nil)
//    }
//
//}

