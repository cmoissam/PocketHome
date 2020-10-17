//
//  DashboardViewModel.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol DashboardDrawableModule {
    var moduleId: Int { get }
    var productType: ProductType { get }
    var moduleName: String { get }
}

class DashboardViewModel {
    let modulesPublisher: PublishSubject<[DashboardDrawableModule]> = PublishSubject()
    let heatersSelectedPublisher: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let rollersSelectedPublisher: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let lightsSelectedPublisher: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var disposeBag = DisposeBag()
    
    private let storeService: StoreService
    
    init(storeService: StoreService) {
        self.storeService = storeService
    }

    func loadModules() {
        let modules = Observable.combineLatest(
            storeService.heaters.asObservable(),
            storeService.rollerShutters.asObservable(),
            storeService.lights.asObservable(),
            heatersSelectedPublisher.asObservable(),
            rollersSelectedPublisher.asObservable(),
            lightsSelectedPublisher.asObservable()
        ).map({ heaters, rollerShutters, lights, heatersSelected, rollersSelected, lightsSelected -> [DashboardDrawableModule] in
            var modules = [DashboardDrawableModule]()
            if heatersSelected {
                modules.append(contentsOf: heaters)
            }
            if rollersSelected {
                modules.append(contentsOf: rollerShutters)
            }
            if lightsSelected {
                modules.append(contentsOf: lights)
            }
            return modules
        })
        modules.asObservable().observe(on: MainScheduler.instance)
            .bind(to: modulesPublisher)
            .disposed(by: disposeBag)
       
    }

    func deleteModule(for id: Int) {
        storeService.deleteModule(for: id)
    }
}
