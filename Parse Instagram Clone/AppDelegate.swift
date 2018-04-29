//
//  AppDelegate.swift
//  Parse Instagram Clone
//
//  Created by Sophian on 8/7/17.
//  Copyright © 2017 Sophian. All rights reserved.
//

import UIKit
import Parse
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //ONE SIGNAL
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "your_onesignal_id",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
        
        
        
        let config = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "your_parse_applicationid"
            ParseMutableClientConfiguration.clientKey = "your_parsekey"
            ParseMutableClientConfiguration.server = "your_server_address:80/parse"
        }
        
        Parse.initialize(with: config)
        
        let defaultACL = PFACL()
        defaultACL.getPublicReadAccess = true
        defaultACL.getPublicWriteAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        rememberLogIn()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func rememberLogIn(){
        let user : String? = UserDefaults.standard.string(forKey: "userloggedin")
        if user != nil{
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            window?.rootViewController = tabBar
        }
    }


}

