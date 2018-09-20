//
//  AppDelegate.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 09.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let loginControler = LoginController()
        loginControler.view.backgroundColor = .white
        if let window = self.window{
            window.rootViewController = loginControler
            window.makeKeyAndVisible()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?)
        return true
    }
}
