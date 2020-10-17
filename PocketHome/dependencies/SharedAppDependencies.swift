//
//  SharedAppDependencies.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/08/2020.
//  Copyright © 2020 Issam Lanouari. All rights reserved.
//

import Foundation
import UIKit

protocol SharedRootContainer: class {
    func makeDashboardViewController(coordinator: AppRoutingLogic) -> UIViewController
    func makeUserProfileViewController() -> UIViewController
    func makeHeaterViewController(moduleId: Int) -> UIViewController
    func makeLighViewController(moduleId: Int) -> UIViewController
    func makeRollerShutterViewController(moduleId: Int) -> UIViewController
}

class SharedAppDependencies: SharedRootContainer {
    
    let storeService = StoreService()
    
    func makeDashboardViewController(coordinator: AppRoutingLogic) -> UIViewController {
        UIViewController()
    }
    
    func makeUserProfileViewController() -> UIViewController {
        UIViewController()
    }
    
    func makeHeaterViewController(moduleId: Int) -> UIViewController {
        UIViewController()
    }
    
    func makeLighViewController(moduleId: Int) -> UIViewController {
        UIViewController()
    }
    
    func makeRollerShutterViewController(moduleId: Int) -> UIViewController {
        UIViewController()
    }
}
