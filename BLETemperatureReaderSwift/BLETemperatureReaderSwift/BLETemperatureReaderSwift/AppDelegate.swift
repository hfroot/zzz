//
//  AppDelegate.swift
//  iOSRemoteConfBLEDemo
//
//  Created by Evan Stone on 4/9/16.
//  Copyright © 2016 Cloud City. All rights reserved.
//

import UIKit
import RealmSwift

final class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let sensorData = List<sensorDataObject>()
}

final class sensorDataObject: Object {
    dynamic var sensorID = ""
    dynamic var sensorTimestamp = NSDate()
    dynamic var sensorTemp: Float = 0.0
    dynamic var sensorHumi: Float = 0.0
    //dynamic var sensorLight: Double = 0.0
    //dynamic var sensorNoise: Double = 0.0
    //dynamic var sensorAccel: Double = 0.0
}

let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
let realm = try! Realm(configuration: config)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //setDefaultRealmForUser(username: "Pierre")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }

}

