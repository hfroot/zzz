//
//  LoginTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

// This tasks presents the login step.
public var LoginTask: ORKOrderedTask {
    
    /*
     A login step view controller subclass is required in order to use the login step.
     The subclass provides the behavior for the login step forgot password button.
     */
    class LoginViewController : ORKLoginStepViewController {
//        override func forgotPasswordButtonTapped() {
//            let alertTitle = NSLocalizedString("Not registered yet?", comment: "")
//            let alertMessage = NSLocalizedString("Please create an account to log in", comment: "")
//            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            let registerAction = UIAlertAction(title: "Register", style: .default) { (_) -> Void in
//                
//                self.performSegue(withIdentifier: "show_registration_screen", sender: self)
//            }
//            
//            alert.addAction(registerAction)
//            alert.addAction(cancelAction)
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    /*
     A login step provides a form step that is populated with email and password fields,
     and a button for `Forgot password?`.
     */
    let loginTitle = NSLocalizedString("Login", comment: "")
    let loginStep = ORKLoginStep(identifier: "LoginStep", title: loginTitle, text: "Please login to use to ZZZ app", loginViewControllerClass: LoginViewController.self)
    
    /*
     A wait step allows you to validate the data from the user login against your server before proceeding.
     */
//    let waitTitle = NSLocalizedString("Logging in", comment: "")
//    let waitText = NSLocalizedString("Please wait while we validate your credentials", comment: "")
//    let waitStep = ORKWaitStep(identifier: "LoginWaitStep")
//    waitStep.title = waitTitle
//    waitStep.text = waitText
    
    return ORKOrderedTask(identifier: "LoginTask", steps: [loginStep])
}
