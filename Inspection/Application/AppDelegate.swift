//
//  AppDelegate.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialSetup()
        return true
    }

    private func initialSetup() {
        IQKeyboardManager.shared.enable = true
    }
}

