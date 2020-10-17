//
//  RollerShutter.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

class RollerShutter: Module, DashboardDrawableModule {
    var position: Int
    
    enum CodingKeys: String, CodingKey {
        case position
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.position = try container.decode(Int.self, forKey: .position)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try super.encode(to: encoder)
    }
}
