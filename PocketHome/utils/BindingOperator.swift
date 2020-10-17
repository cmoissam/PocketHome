//
//  BindingOperator.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import Foundation
import RxCocoa
import RxSwift

infix operator <->
@discardableResult func <-><T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .subscribe(
            onNext: { variable.accept($0) },
            onCompleted: { variableToProperty.dispose() }
    )

    return Disposables.create(variableToProperty, propertyToVariable)
}
