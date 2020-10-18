//
//  HeaterViewModel.swift
//  PocketHome
//
//  Created by Issam Lanouari on 18/10/2020.
//

import Foundation
import RxCocoa
import RxSwift

class HeaterViewModel {
    let productName: String
    let mode: BehaviorRelay<Bool>
    let temperature: BehaviorRelay<Float>
    
    private let disposeBag = DisposeBag()
    private let storeService: StoreService
    
    init(storeService: StoreService, moduleId: Int) {
        self.storeService = storeService
        guard let heater = self.storeService.heaters.value.first(where: {$0.moduleId == moduleId}) else {
            assertionFailure("should not happen")
            self.productName = ""
            self.mode = BehaviorRelay<Bool>(value: false)
            self.temperature = BehaviorRelay<Float>(value: 0)
            return
        }
        self.productName = heater.moduleName
        self.mode = BehaviorRelay<Bool>(value: heater.mode.toBool())
        self.temperature = BehaviorRelay<Float>(value: heater.temperature)
        
        Observable.combineLatest(
            mode.asObservable(),
            temperature.asObservable().debounce(.milliseconds(500), scheduler: MainScheduler.instance),
            resultSelector: { [weak self] mode, temperature in
                heater.update(
                    with: PowerMode(boolMode: mode),
                    temperature: temperature
                )
                self?.storeService.updateHeaterState(heater: heater)
            }).observe(on: MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
        
    }
}

