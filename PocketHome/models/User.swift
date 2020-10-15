//
//  User.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

struct User: Codable {
    var firstName: String
    var lastName: String
    var address: Adress
    var birthDate: Date
    
    init() {
        firstName = "Issam"
        lastName = "Lanouari"
        address = Adress()
        birthDate = Date()
    }
}

struct Adress: Codable {
    var city: String
    var postalCode: Int
    var street: String
    var streetCode: String
    var country: String
    
    init() {
        city = "Puteaux"
        postalCode = 92800
        street = "quai de dion bouton"
        streetCode = "34"
        country = "France"
    }
}


