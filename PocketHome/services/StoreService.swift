//
//  StoreService.swift
//  PocketHome
//
//  Created by Issam Lanouari on 16/10/2020.
//

import Foundation
import RxCocoa

class StoreService {

    var user: BehaviorRelay<User> = BehaviorRelay(value: User())
    var heaters: BehaviorRelay<[Heater]> = BehaviorRelay(value: [])
    var rollerShutters: BehaviorRelay<[RollerShutter]> = BehaviorRelay(value: [])
    var lights: BehaviorRelay<[Light]> = BehaviorRelay(value: [])

    private let endPointString = "http://storage42.com/modulotest/data.json"
    private lazy var localUrl: URL? = {
        let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
        ).first
        let pathWithFileName = documentDirectory?.appendingPathComponent("JsonData")
        return pathWithFileName
    }()

    fileprivate func readDataFromLocalFile() -> Home? {
        guard let localUrl = localUrl else {
            debugPrint("Cannot get JSON from Document Directory")
            return  nil
        }
        do {
            let jsonData = try Data(contentsOf: localUrl)
            let decodedModel = try JSONDecoder().decode(Home.self, from: jsonData)
            return decodedModel
        } catch {
            debugPrint(error)
        }
        return nil
    }

    fileprivate func fetchRemoteData() {
        let request = URLRequest(url: URL(string: endPointString)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
          guard let HTTPResponse = response as? HTTPURLResponse else {
            debugPrint("error")
            return
          }
          
          switch HTTPResponse.statusCode {
          case 200:
            guard let data = data, data.count > 0 else { return }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
            do {
                let decodedModel = try jsonDecoder.decode(Home.self, from: data)
                self.notifyStore(model: decodedModel)
            } catch {
              debugPrint("Parsing error : \(error)")
            }
          default:
            debugPrint("Parsing error \(HTTPResponse.statusCode)")
          }
        }
        task.resume()
    }

    func storeDataInLocalFile() {
        do {
            guard let localUrl = localUrl else {
                debugPrint("Cannot get JSON from Document Directory")
                return
            }
            let jsonEncoder = JSONEncoder()
            let home = Home(
                heaters: heaters.value,
                rollerShutters: rollerShutters.value,
                lights: lights.value,
                user: user.value
            )
            let jsonData = try jsonEncoder.encode(home)
            try jsonData.write(to: localUrl)
        } catch {
            debugPrint("Parsing error : \(error)")
        }
    }

    func loadData() {
        guard let home = readDataFromLocalFile() else {
            fetchRemoteData()
            return
        }
        notifyStore(model: home)
    }

    fileprivate func notifyStore(model: Home) {
        user.accept(model.user)
        heaters.accept(model.heaters)
        rollerShutters.accept(model.rollerShutters)
        lights.accept(model.lights)
    }
}

extension StoreService {

    func deleteModule(for id: Int) {
        var heaters = self.heaters.value
        heaters.removeAll(where: { $0.moduleId == id })
        self.heaters.accept(heaters)
        
        var rollerShutters = self.rollerShutters.value
        rollerShutters.removeAll(where: { $0.moduleId == id })
        self.rollerShutters.accept(rollerShutters)
        
        var lights = self.lights.value
        lights.removeAll(where: { $0.moduleId == id })
        self.lights.accept(lights)
    }

    func updateUser(with user: User) {
        self.user.accept(user)
    }

    func updateHeaterState(heater: Heater) {
        let heaters = self.heaters.value
        let updatedHeaters: [Heater] = heaters.map {
            if $0.moduleId == heater.moduleId { return heater }
            return $0
        }
        self.heaters.accept(updatedHeaters)
    }
    
    func updateLightState(light: Light) {
        let lights = self.lights.value
        let updatedLights: [Light] = lights.map {
            if $0.moduleId == light.moduleId { return light }
            return $0
        }
        self.lights.accept(updatedLights)
    }
    
    func updateRollerShutterState(rollerShutter: RollerShutter) {
        let rollerShutters = self.rollerShutters.value
        let updatedRollerShutters: [RollerShutter] = rollerShutters.map {
            if $0.moduleId == rollerShutter.moduleId { return rollerShutter }
            return $0
        }
        self.rollerShutters.accept(updatedRollerShutters)
    }
}
