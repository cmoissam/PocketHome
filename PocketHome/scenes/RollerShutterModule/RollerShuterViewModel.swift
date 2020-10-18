//
//  RollerShuterViewModel.swift
//  PocketHome
//
//  Created by Issam Lanouari on 18/10/2020.
//

import Foundation
import RxCocoa
import RxSwift

class RollerShuterViewModel {
    let productName: String
    let position: BehaviorRelay<Int>
    
    private let disposeBag = DisposeBag()
    private let storeService: StoreService
    
    init(storeService: StoreService, moduleId: Int) {
        self.storeService = storeService
        guard let rollerShutter = self.storeService.rollerShutters.value.first(where: {$0.moduleId == moduleId}) else {
            assertionFailure("should not happen")
            self.productName = ""
            self.position = BehaviorRelay<Int>(value: 0)
            return
        }
        self.productName = rollerShutter.moduleName
        self.position = BehaviorRelay<Int>(value: rollerShutter.position)
        
        position
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (position) in
            rollerShutter.position = position
            self?.storeService.updateRollerShutterState(rollerShutter: rollerShutter)
        }).disposed(by: disposeBag)
    }
}
