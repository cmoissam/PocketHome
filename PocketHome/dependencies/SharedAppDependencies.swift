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
        DashboardViewController(
            coordinator: coordinator,
            viewModel: DashboardViewModel(storeService: storeService)
        )
    }
    
    func makeUserProfileViewController() -> UIViewController {
        UserProfileViewController(
            viewModel: UserProfileViewModel(storeService: storeService)
        )
    }
    
    func makeHeaterViewController(moduleId: Int) -> UIViewController {
        HeatersViewController(
            viewModel: HeaterViewModel(storeService: storeService, moduleId: moduleId)
        )
    }
    
    func makeLighViewController(moduleId: Int) -> UIViewController {
        LightsViewController(
            viewModel: LightViewModel(storeService: storeService, moduleId: moduleId)
        )
    }
    
    func makeRollerShutterViewController(moduleId: Int) -> UIViewController {
        UIViewController()
    }
}
