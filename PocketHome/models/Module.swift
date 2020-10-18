//
//  Module.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

class Module: Codable {
    private(set) var moduleId: Int
    private(set) var moduleName: String
    private(set) var productType: ProductType
    
    enum CodingKeys: String, CodingKey {
        case moduleId = "id", moduleName = "deviceName", productType
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.moduleId = try container.decode(Int.self, forKey: .moduleId)
        self.moduleName = try container.decode(String.self, forKey: .moduleName)
        self.productType = try container.decode(ProductType.self, forKey: .productType)
    }
}

enum ProductType: String, Codable, CaseIterable {
    case Heater, RollerShutter, Light
    
    var iconName: String {
        switch self {
        case .Heater:
            return "heater"
        case .RollerShutter:
            return "rollerShutter"
        case .Light:
            return "light"
        }
    }
}

enum PowerMode: String, Codable {
    case ON, OFF
    
    func toBool() -> Bool{
        self == .ON ? true : false
    }
    
    init(boolMode: Bool) {
        self = boolMode ? .ON : .OFF
    }
}
