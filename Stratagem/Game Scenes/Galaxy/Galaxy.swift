import SpriteKit

class Galaxy {
    var planetLocs: [CGPoint] = []
    var planets: [Planet] = []
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
        
        let potentialPlanetNames = getListOfNames(fileName: "planet_names")!.shuffled()
        let potentialCityNames = getListOfNames(fileName: "city_names")!.shuffled()
        
        var j = 0
        for i in 0..<numPlanets {
            var planetName = potentialPlanetNames[i]
            planetName.removeLast(2) // removes the \r
            
            let planet = Planet(planetName: planetName)
            
            let numCities = Int.random(in: 1..<4)
            planet.generateAllCities(cityNames: Array(potentialCityNames[j..<j+numCities]))
            planets.append(planet)
            j += numCities
        }
    }
    
    init() {
        
    }
}
