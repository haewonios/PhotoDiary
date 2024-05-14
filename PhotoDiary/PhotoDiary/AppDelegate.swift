//
//  AppDelegate.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = ListViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

