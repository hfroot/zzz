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
