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
    var birthDate = BehaviorRelay<String>(value: "")
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
        birthDate.accept(dateFormatter.string(from: storeService.user.value.birthDate))
        city.accept(storeService.user.value.address.city)
        street.accept(storeService.user.value.address.street)
        streetCode.accept(storeService.user.value.address.streetCode)
        country.accept(storeService.user.value.address.country)
        postalCode.accept(String(storeService.user.value.address.postalCode))
    }
    func saveProfile() {
        var user = storeService.user.value
        user.firstName = firstName.value
        user.lastName = lastName.value
        if let safeBirthDate = dateFormatter.date(from: birthDate.value) {
            user.birthDate = safeBirthDate
        }
        if let safePostalCode = Int(postalCode.value) {
            user.address.postalCode = safePostalCode
        }
        user.address.city = city.value
        user.address.street = street.value
        user.address.streetCode = streetCode.value
        user.address.country = country.value
        storeService.updateUser(with: user)
    }
}
