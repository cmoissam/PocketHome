//
//  Light.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

class Light: Module {
    var intensity: Int
    var mode: PowerMode
    
    enum CodingKeys: String, CodingKey {
        case intensity, mode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.intensity = try container.decode(Int.self, forKey: .intensity)
        self.mode = try container.decode(PowerMode.self, forKey: .mode)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intensity, forKey: .intensity)
        try container.encode(mode, forKey: .mode)
        try super.encode(to: encoder)
    }
}
