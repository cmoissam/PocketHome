//
//  User.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

struct User: Codable {
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var address: Adress
    private(set) var birthDate: Date?
    
    init() {
        firstName = "Issam"
        lastName = "Lanouari"
        address = Adress()
        birthDate = Date()
    }

    init(
        firstName: String,
        lastName: String,
        address: Adress,
        birthDate: Date?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.birthDate = birthDate
    }
}

struct Adress: Codable {
    private(set) var city: String
    private(set) var postalCode: Int?
    private(set) var street: String
    private(set) var streetCode: String
    private(set) var country: String
    
    init() {
        city = "Puteaux"
        postalCode = 92800
        street = "quai de dion bouton"
        streetCode = "34"
        country = "France"
    }

    init(
        city: String,
        postalCode: Int?,
        street: String,
        streetCode: String,
        country: String
    ) {
        self.city = city
        self.postalCode = postalCode
        self.street = street
        self.streetCode = streetCode
        self.country = country
    }
}


