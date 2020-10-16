//
//  ModelDecodeTest.swift
//  PocketHomeTests
//
//  Created by Issam Lanouari on 16/10/2020.
//

import XCTest
@testable import PocketHome

class ModelDecodeTest: XCTestCase {
    
    func getJsonData(from resource: String) -> Data {
        guard let pathString = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json") else {
            fatalError("ressources not found")
        }
        guard let jsonData = try? Data(contentsOf: pathString) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        return jsonData
    }
    
    func test_decode_modules() {
        do {
            let jsonData = getJsonData(from: "modulesData")
            let modules = try JSONDecoder().decode([Module].self, from: jsonData)
            XCTAssertFalse(modules.isEmpty)
            XCTAssertEqual(modules.count, 3)
        } catch {
            XCTFail("Can't decode data")
        }
    }

    func test_decode_heaters() {
        do {
            let jsonData = getJsonData(from: "heatersData")
            let modules = try JSONDecoder().decode([Heater].self, from: jsonData)
            XCTAssertFalse(modules.isEmpty)
            XCTAssertEqual(modules.count, 2)
            XCTAssertFalse(modules.map({ $0.productType }).contains(.Light))
            XCTAssertFalse(modules.map({ $0.productType }).contains(.RollerShutter))
            XCTAssertEqual(modules.first(where: { $0.moduleId == 1 })?.temperature, 30)
            XCTAssertEqual(modules.first(where: { $0.moduleId == 2 })?.moduleName, "Radiateur - Chambre")
        } catch {
            XCTFail("Can't decode data")
        }
    }

    func test_decode_roller_shutters() {
        do {
            let jsonData = getJsonData(from: "rollerShuttersData")
            let modules = try JSONDecoder().decode([RollerShutter].self, from: jsonData)
            XCTAssertFalse(modules.isEmpty)
            XCTAssertEqual(modules.count, 2)
            XCTAssertFalse(modules.map({ $0.productType }).contains(.Heater))
            XCTAssertFalse(modules.map({ $0.productType }).contains(.Light))
            XCTAssertEqual(modules.first(where: { $0.moduleId == 1 })?.position, 70)
            XCTAssertEqual(modules.first(where: { $0.moduleId == 2 })?.moduleName, "Volet roulant - Salon")
        } catch {
            XCTFail("Can't decode data")
        }
    }

    func test_decode_lights() {
        do {
            let jsonData = getJsonData(from: "lightsData")
            let modules = try JSONDecoder().decode([Light].self, from: jsonData)
            XCTAssertFalse(modules.isEmpty)
            XCTAssertEqual(modules.count, 2)
            XCTAssertFalse(modules.map({ $0.productType }).contains(.Heater))
            XCTAssertFalse(modules.map({ $0.productType }).contains(.RollerShutter))
            XCTAssertEqual(modules.first(where: { $0.moduleId == 1 })?.intensity, 50)
            XCTAssertEqual(modules.first(where: { $0.moduleId == 2 })?.moduleName, "Lampe - Couloir")
            
        } catch {
            XCTFail("Can't decode data")
        }
    }

    func test_decode_user() {
        do {
            let jsonData = getJsonData(from: "userData")
            let user = try JSONDecoder().decode(User.self, from: jsonData)
            XCTAssertNotNil(user)
            XCTAssertEqual(user.firstName, "Issam")
            XCTAssertEqual(user.address.streetCode, "34")
            
        } catch {
            XCTFail("Can't decode data")
        }
    }

    func test_decode_home() {
        do {
            let jsonData = getJsonData(from: "homeData")
            let home = try JSONDecoder().decode(Home.self, from: jsonData)
            XCTAssertNotNil(home)
            XCTAssertEqual(home.heaters.count, 1)
            XCTAssertEqual(home.user.lastName, "Lanouari")
            XCTAssertEqual(home.rollerShutters.first?.moduleId, 2)
            XCTAssertEqual(home.lights.first?.moduleName, "Lampe - Cuisine")
        } catch {
            XCTFail("Can't decode data")
        }
    }
}
