//
//  Home.swift
//  PocketHome
//
//  Created by Issam Lanouari on 15/10/2020.
//

import Foundation

class Home: Codable {

    var heaters: [Heater]
    var rollerShutters: [RollerShutter]
    var lights: [Light]
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case devices, user
    }
    
    init(
        heaters: [Heater],
        rollerShutters: [RollerShutter],
        lights: [Light],
        user: User
    ) {
        self.heaters = heaters
        self.rollerShutters = rollerShutters
        self.lights = lights
        self.user = user
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var devices: [Module] = []
        devices.append(contentsOf: heaters)
        devices.append(contentsOf: rollerShutters)
        devices.append(contentsOf: lights)
        try container.encode(devices, forKey: .devices)
        try container.encode(user, forKey: .user)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(User.self, forKey: .user)
        var includedArray = try container.nestedUnkeyedContainer(forKey: .devices)
        var heaters: [Heater] = []
        var rollerShutters: [RollerShutter] = []
        var lights: [Light] = []

        while !includedArray.isAtEnd {
            if let heater = try? includedArray.decode(Heater.self) {
                heaters.append(heater)
            }
            else if let rollerShutter = try? includedArray.decode(RollerShutter.self) {
                rollerShutters.append(rollerShutter)
            }
            else if let light = try? includedArray.decode(Light.self) {
                lights.append(light)
            }
        }
        self.heaters = heaters
        self.rollerShutters = rollerShutters
        self.lights = lights
    }
}
