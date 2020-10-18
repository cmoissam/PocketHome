//
//  Heater.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

class Heater: Module, DashboardDrawableModule {

    private(set) var temperature: Float
    private(set) var mode: PowerMode
    
    enum CodingKeys: String, CodingKey {
        case temperature, mode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(Float.self, forKey: .temperature)
        self.mode = try container.decode(PowerMode.self, forKey: .mode)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(mode, forKey: .mode)
        try super.encode(to: encoder)
    }
}

extension Heater {
    func update(
        with mode: PowerMode,
        temperature: Float
    ) {
        self.mode = mode
        self.temperature = temperature
    }
}
