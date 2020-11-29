import SpriteKit

class Galaxy {
    var planetLocs: [CGPoint] = []
    var planets: [Planet] = []
    
    func generateNewGalaxy(_ gameType: GameTypes){
        var numPlanets: Int
        
        switch gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        for i in 0..<numPlanets {
            planets.append(Planet(planetID: i))
        }
        
        // only generate one planet for now
        planets[0].generateNewCity()
    }
}
