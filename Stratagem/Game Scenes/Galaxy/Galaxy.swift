import SpriteKit

class Galaxy {
    var planetLocs: [CGPoint] = []
    var planets: [Planet] = []
    
    /// Player specific
    var ownedPlanetIDs: [Int] = []
    
    func generateNewGalaxy(){
        var numPlanets: Int
        
        switch Global.gameVars?.gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        for i in 0..<numPlanets {
            planets.append(Planet(planetID: i))
        }
    }
}
