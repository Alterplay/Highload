//
//  AppDelegate.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        /* Check if real device */
        if UIDevice.currentDevice().model != "iPhone Simulator" {
            let alert = UIAlertView()
            alert.title = "You are about to run Highload on a real device. Be carefull to not screw up"
            alert.addButtonWithTitle("Got it")
            alert.show()
        }
        
        return true
    }
}

