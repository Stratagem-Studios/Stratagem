import SpriteKit

class Galaxy {
    var planetLocs: [CGPoint] = []
    var planets: [Planet] = []
    var galaxyScene: GalaxyScene!
    
    /// Player specific
    var ownedPlanetNames: [String] = []
    
    func generateNewGalaxy(){
        var numPlanets: Int
        switch Global.gameVars?.gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        
        let planetNames = getListOfNames(fileName: "planet_names")!.choose(numPlanets)

        for i in 0..<numPlanets {
            var planetName = planetNames[i]
            planetName.removeLast(2)
            planets.append(Planet(planetName: planetName))
            planets[i].generateNewCity(cityName: "f")
        }
        
    }
    
    init() {
        
    }
}
