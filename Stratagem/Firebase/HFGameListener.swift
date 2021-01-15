// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct HFGameListener {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func listenToAll() {
        listenForCityChanges()
        listenForPlanetChanges()
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
                    
                    if city.owner != Global.playerVariables.playerName {
                        city.cityTerrainInt = cityTerrain
                        city.resources = resourceStringToDict(input: cityInfo["resources"] as! String)
                    }
                    city.units = unitsStringToDict(input: cityInfo["units"] as! String)
                }
            }
        })
        playerVariables.observerRefs.append(citiesRef)
    }
    
    public func listenForPlanetChanges() {
        let planetsRef = ref.child("games").child(staticGameVariables.gameCode).child("planets")
        planetsRef.observe(.value, with: { snapshot in
                for planet in Global.gameVars.galaxy.planets{
                    print(planet.planetName + "/owner")
                    planet.owner = snapshot.childSnapshot(forPath: planet.planetName + "/owner").value as? String
                }
            Global.gameVars.checkGameOver()
        })
        playerVariables.observerRefs.append(planetsRef)
    }
    
    
    func resourceStringToString(input: String) -> ([String], [CGFloat]) {
        let text = input.replacingOccurrences(of: "]", with: ",")
        let regex = try! NSRegularExpression(pattern:"\"(.*?)\"", options: [])
        var resourceNames = [String]()

        regex.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: text) {
                resourceNames.append(String(text[range]))
            }
        }
        
        let regexVals = try! NSRegularExpression(pattern:",(.*?),", options: [])
        var resourceValues = [CGFloat]()

        regexVals.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: text) {
                resourceValues.append(CGFloat(Float(text[range])!))
            }
        }
        return (resourceNames, resourceValues)
    }

    
    
    func resourceStringToDict(input: String) -> [ResourceTypes: CGFloat] {
        let resourceInfo = resourceStringToString(input: input)
        
        var resources: [ResourceTypes: CGFloat] = [:]
        for (i, resourceName) in resourceInfo.0.enumerated() {
            resources[ResourceTypes(rawValue: resourceName)!] = resourceInfo.1[i]
        }

        return resources
    }
    
    func unitsStringToDict(input: String) -> [UnitType: Int] {
        let unitInfo = resourceStringToString(input: input)
        
        var units: [UnitType: Int] = [:]
        for (i, unitName) in unitInfo.0.enumerated() {
            units[UnitType(rawValue: unitName)!] = Int(unitInfo.1[i])
        }

        return units
    }
 

}
