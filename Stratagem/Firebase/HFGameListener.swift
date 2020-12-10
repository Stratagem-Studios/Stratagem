// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct HFGameListener {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func listenToAll() {
        listenForCityChanges()
    }
    
    public func listenForCityChanges() {
        let citiesRef = ref.child("games").child(staticGameVariables.gameCode).child("cities")
        citiesRef.observe(.value, with: { snapshot in
            let enumerator = snapshot.children
            while let obj = enumerator.nextObject() as? DataSnapshot {
                if let cityInfo = obj.value as? Dictionary<String, Any> {
                    let city = Global.gameVars.galaxy.planets.filter({$0.planetName == cityInfo["planetName"] as? String}).first!.cities.filter({$0.cityName == obj.key}).first!
                    city.owner = cityInfo["owner"] as? String

                    let cityTerrainFlattened = (cityInfo["cityTerrainFlattened"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                        .components(separatedBy:",").map { Int($0)!}
                    var cityTerrain: [[Int]] = Array(repeating: Array(repeating: 0, count: city.cityHeight), count: city.cityWidth)
                    for x in 0..<city.cityWidth {
                        for y in 0..<city.cityHeight {
                            cityTerrain[x][y] = cityTerrainFlattened[x * city.cityWidth + y]
                        }
                    }
                }
            }
        })
        playerVariables.observerRefs.append(citiesRef)
    }
    
    /*
    func resourceStringToDict(text: String) -> [ResourceTypes: CGFloat] {
        print(text)
        let resources: [ResourceTypes: CGFloat] = [:]
        return resources
    }
 */

}
