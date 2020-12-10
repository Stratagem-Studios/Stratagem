// Mediates connection from GameVariables -> Firebase (manually update)

import Firebase
import SwiftUI

public struct HFGamePusher {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    /// Uplaods a 2d array of tile IDs to Firebase
    public func uploadCityTerrain(cityName: String, cityTerrain: [[CityTile]]? = nil, cityTerrainInt: [[Int]]? = nil) {
        var cityTerrainFlattened: [Int] = []
        
        if let cityTerrain = cityTerrain {
            for (_, item) in cityTerrain.enumerated() {
                for cityTile in item {
                    cityTerrainFlattened.append((cityTile.tile?.tileData.globalID)!)
                }
            }
        } else if let cityTerrainInt = cityTerrainInt {
            for (_, item) in cityTerrainInt.enumerated() {
                for cityTile in item {
                    cityTerrainFlattened.append(cityTile)
                }
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
}
