// Mediates connection from GameVariables -> Firebase (manually update)

import Firebase
import SwiftUI

public struct HFGamePusher {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    /// Changes the owner of a type: "planets" or "cities"
    public func updateOwnership(type: String, name: String, newOwner: String) {
        ref.child("games/\(staticGameVariables.gameCode)/\(type)/\(name)/owner").setValue(newOwner)
    }
    
    /// Uplaods a 2d array of tile IDs to Firebase
    public func uploadCityTerrain(cityName: String, cityTerrainInt: [[Int]]) {
        var cityTerrainFlattened: [Int] = []
        
        for (_, item) in cityTerrainInt.enumerated() {
            for cityTile in item {
                cityTerrainFlattened.append(cityTile)
            }
        }
        
        let encoder = JSONEncoder()
        do {
            let string = String(data: try encoder.encode(cityTerrainFlattened), encoding: .utf8)!
            ref.child("games/\(staticGameVariables.gameCode)/cities/\(cityName)/cityTerrainFlattened").setValue(string)
        } catch {
            print("Unable to encode terrain")
        }
    }
    
    public func uploadResources(cityName: String, name: String, resources: [ResourceTypes: CGFloat]) {
        let encoder = JSONEncoder()
        do {
            let string = String(data: try encoder.encode(resources), encoding: .utf8)!
            ref.child("games/\(staticGameVariables.gameCode)/cities/\(cityName)/\(name)").setValue(string)
        } catch {
            print("Unable to encode resources")
        }
    }
    
    public func uploadUnits(cityName: String, units: [UnitType: Int]) {
        let encoder = JSONEncoder()
        do {
            let string = String(data: try encoder.encode(units), encoding: .utf8)!
            ref.child("games/\(staticGameVariables.gameCode)/cities/\(cityName)/units").setValue(string)
        } catch {
            print("Unable to encode resources")
        }
    }
}
