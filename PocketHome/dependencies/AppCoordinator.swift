//
//  AppCoordinator.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//  Copyright © 2020 Issam Lanouari. All rights reserved.
//

import Foundation
import UIKit

protocol AppRoutingLogic: class {
    func showUserProfileViewController()
    func showHeaterViewController(moduleId: Int)
    func showLighViewController(moduleId: Int)
    func showRollerShutterViewController(moduleId: Int)
}

class AppCoordinator: AppRoutingLogic {

    let rootViewController = AppNavigationController()
    let appDependencies: SharedRootContainer
    
    init(appDependencies: SharedRootContainer) {
        self.appDependencies = appDependencies
        self.rootViewController.viewControllers = [appDependencies.makeDashboardViewController(coordinator: self)]
    }

    func showUserProfileViewController() {
        let vc = appDependencies.makeUserProfileViewController()
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func showHeaterViewController(moduleId: Int) {
        let vc = appDependencies.makeHeaterViewController(moduleId: moduleId)
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func showLighViewController(moduleId: Int) {
        let vc = appDependencies.makeLighViewController(moduleId: moduleId)
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func showRollerShutterViewController(moduleId: Int) {
        let vc = appDependencies.makeRollerShutterViewController(moduleId: moduleId)
        rootViewController.pushViewController(vc, animated: true)
    }
}

class AppNavigationController: UINavigationController {
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .white
        navigationBar.barStyle = .black
        navigationBar.backgroundColor = .systemBlue
        
        // A small hack to hide back button text in all navigations bar in the app
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
    }
}
