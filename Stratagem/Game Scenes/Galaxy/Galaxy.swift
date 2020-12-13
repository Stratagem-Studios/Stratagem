import SpriteKit

class Galaxy {
    var planetLocs: [CGPoint] = []
    var planets: [Planet] = []
    var planetTransfers: [PlanetTransfer] = []
    var galaxyScene: GalaxyScene!
    
    /// Generates all the planets and cities in a galaxy
    func generateNewGalaxy(){
        var numPlanets: Int
        switch Global.gameVars?.gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        
        var potentialPlanetNames = getListOfNames(fileName: "planet_names")!.shuffled()
        var potentialCityNames = getListOfNames(fileName: "city_names")!.shuffled()
        potentialPlanetNames.remove(object: "")
        potentialCityNames.remove(object: "")
        
        var j = 0
        for i in 0..<numPlanets {
            var planetName = potentialPlanetNames[i]
            planetName.removeLast() // removes the \r
            
            let planet = Planet(planetName: planetName)
            
            let numCities = Int.random(in: 1..<4)
            planet.generateAllCities(cityNames: Array(potentialCityNames[j..<j+numCities]))
            planets.append(planet)
            j += numCities
        }
    }
    
    
    
    func update(dt: CGFloat) {
        var transfersIntsToRemove: [Int] = []
        print(planetTransfers.count)
        for i in 0..<planetTransfers.count {
            if planetTransfers[i].timePassed(dt: dt) {
                transfersIntsToRemove.append(i)
            }
        }
        for i in transfersIntsToRemove {
            planetTransfers.remove(at: i)
        }
    }
}
