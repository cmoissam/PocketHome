//
//  UserProfileViewModel.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import Foundation
import RxCocoa

class UserProfileViewModel {
    var firstName = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    var birthDate = BehaviorRelay<String?>(value: "")
    var city = BehaviorRelay<String>(value: "")
    var street = BehaviorRelay<String>(value: "")
    var streetCode = BehaviorRelay<String>(value: "")
    var country = BehaviorRelay<String>(value: "")
    var postalCode = BehaviorRelay<String>(value: "")
    
    private let storeService: StoreService
    
    lazy var dateFormatter: DateFormatter = {
        let dateFromatter = DateFormatter()
        dateFromatter.dateStyle = .medium
        return dateFromatter
    }()
    
    init(storeService: StoreService) {
        self.storeService = storeService
        firstName.accept(storeService.user.value.firstName)
        lastName.accept(storeService.user.value.lastName)
        birthDate.accept(dateFormatter.string(from: storeService.user.value.birthDate ?? Date()))
        city.accept(storeService.user.value.address.city)
        street.accept(storeService.user.value.address.street)
        streetCode.accept(storeService.user.value.address.streetCode)
        country.accept(storeService.user.value.address.country)
        postalCode.accept(String(storeService.user.value.address.postalCode ?? 0))
    }
    func saveProfile() {
        let newAdress = Adress(
            city: city.value,
            postalCode: Int(postalCode.value),
            street: street.value,
            streetCode: streetCode.value,
            country: country.value
            )
        let newUser = User(
            firstName: firstName.value,
            lastName: lastName.value,
            address: newAdress,
            birthDate: dateFormatter.date(from: birthDate.value ?? "")
        )

        storeService.updateUser(with: newUser)
    }
}
