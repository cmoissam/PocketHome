//
//  AppDelegate.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    let appDependencies = SharedAppDependencies()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appDependencies.storeService.loadData()
        let coordinator = AppCoordinator(appDependencies: appDependencies)
        window?.rootViewController = coordinator.rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        appDependencies.storeService.storeDataInLocalFile()
    }
}

