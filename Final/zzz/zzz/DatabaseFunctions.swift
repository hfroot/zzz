//
//  DatabaseFunctions.swift
//  zzz
//
//  Created by Pierre Azalbert on 09/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import RealmSwift
import ResearchKit
import Security

func saveSleepData(newSleepData:sleepDataObject) {
    try! realm.write {
        currentUser.sleepData.append(newSleepData)
        realm.add(currentUser, update: true)
        print("Added sleepData object to database: \(newSleepData)")
    }
}

func saveWeightData(newWeightData:weightsDataObject) {
    try! realm.write {
        currentUser.weightsData = newWeightData
        realm.add(currentUser, update: true)
        print("Added weightsData object to database: \(newWeightData)")
    }
}

func registerAccount(registrationData:ORKStepResult) {
    
    let newUser = User()
    
    newUser.email = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemEmail") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.password = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemPassword") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.firstName = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemGivenName") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.lastName = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemFamilyName") as! ORKQuestionResult) as! ORKTextQuestionResult).answer! as! String
    newUser.gender = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemGender") as! ORKQuestionResult) as! ORKChoiceQuestionResult).choiceAnswers![0] as! String
    
    let DoB = ((registrationData.result(forIdentifier: "ORKRegistrationFormItemDOB") as! ORKQuestionResult) as! ORKDateQuestionResult).answer! as! Date
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    newUser.DoB = formatter.string(from: DoB)
    
    let initialWeights = weightsDataObject()
    newUser.weightsData = initialWeights
    
    let initialSchedule = scheduleObject()
    newUser.scheduleData = initialSchedule
    
    try! realm.write {
        realm.add(newUser)
        print("Added User object to database: \(newUser)")
    }

}

func getKey() -> NSData {
    // Identifier for our keychain entry - should be unique for your application
    let keychainIdentifier = "zzz.Realm.EncryptionKey.ImperialCollege.2017"
    let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    // First check in the keychain for an existing key
    var query: [NSString: AnyObject] = [
        kSecClass: kSecClassKey,
        kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
        kSecAttrKeySizeInBits: 512 as AnyObject,
        kSecReturnData: true as AnyObject
    ]
    
    // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
    // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
    var dataTypeRef: AnyObject?
    var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
    if status == errSecSuccess {
        return dataTypeRef as! NSData
    }
    
    // No pre-existing key from this application, so generate a new one
    let keyData = NSMutableData(length: 64)!
    let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
    assert(result == 0, "Failed to get random bytes")
    
    // Store the key in the keychain
    query = [
        kSecClass: kSecClassKey,
        kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
        kSecAttrKeySizeInBits: 512 as AnyObject,
        kSecValueData: keyData
    ]
    
    status = SecItemAdd(query as CFDictionary, nil)
    assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
    
    return keyData
}

