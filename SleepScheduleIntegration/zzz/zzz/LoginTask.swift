//
//  LoginTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import ResearchKit

//private var LoginTask: ORKTask {
//    let step = ORKFormStep(identifier: "LoginStep", title: "Login", text: "Please login to use the ZZZ app")
//    
//    // A first field, for entering an integer.
//    let formItem01Text = NSLocalizedString("Email", comment: "")
//    let formItem01 = ORKFormItem(identifier: "emailField", text: formItem01Text, answerFormat: ORKAnswerFormat.emailAnswerFormat())
//    formItem01.placeholder = NSLocalizedString("your@email.com", comment: "")
//    
//    // A second field, for entering a time interval.
//    let formItem02Text = NSLocalizedString("Password", comment: "")
//    let formItem02 = ORKFormItem(identifier: "passwordField", text: formItem02Text, answerFormat: ORKAnswerFormat.textAnswerFormat())
//    formItem02.placeholder = NSLocalizedString("", comment: "")
//    
//    step.formItems = [
//        formItem01,
//        formItem02
//    ]
//    
//    return ORKOrderedTask(identifier: "LoginTask", steps: [step])
//}


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
