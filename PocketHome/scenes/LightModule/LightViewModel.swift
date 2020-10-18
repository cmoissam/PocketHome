//
//  LightViewModel.swift
//  PocketHome
//
//  Created by Issam Lanouari on 18/10/2020.
//

import Foundation
import RxCocoa
import RxSwift

class LightViewModel {
    let productName: String
    let mode: BehaviorRelay<Bool>
    let intensity: BehaviorRelay<Int>
    
    private let disposeBag = DisposeBag()
    private let storeService: StoreService
    
    init(storeService: StoreService, moduleId: Int) {
        self.storeService = storeService
        guard let light = self.storeService.lights.value.first(where: {$0.moduleId == moduleId}) else {
            assertionFailure("should not happen")
            self.productName = ""
            self.mode = BehaviorRelay<Bool>(value: false)
            self.intensity = BehaviorRelay<Int>(value: 0)
            return
        }
        self.productName = light.moduleName
        self.mode = BehaviorRelay<Bool>(value: light.mode.toBool())
        self.intensity = BehaviorRelay<Int>(value: light.intensity)
        
        Observable.combineLatest(
            mode.asObservable(),
            intensity.asObservable().debounce(.milliseconds(500), scheduler: MainScheduler.instance),
            resultSelector: { [weak self] mode, intensity in
                        light.mode = PowerMode(boolMode: mode)
                        light.intensity = intensity
                        self?.storeService.updateLightState(light: light)
            }).observe(on: MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
        
    }
}
