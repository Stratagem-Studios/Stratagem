import SpriteKit
import SceneKit

class Planet {
    var planetName: String! // Firebase
    var owner: String! // Firebase
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    
    // for map
    var cityLocs: [CGPoint] = []
    var unitTiles: [UIImage] = []
    
    /// loc on a 1 x 1, used for planet mapping
    var cityMapping: [CGRect] = [] // Firebase
    var planetMap = PlanetMap(size: CGSize(width: 1000, height: 1000))
    
    init(planetName: String) {
        self.planetName = planetName
    }
    
    func update(deltaTime: CGFloat) {
        for city in cities.filter({$0.owner == Global.playerVariables.playerName}) {
            city.update(deltaTime: deltaTime)
        }
    }
    
    /// Generate all the cities of the planet given random names
    func generateAllCities(cityNames: [String]) {
        for cityName in cityNames {
            let city = City()
            city.initCity(cityName: cityName, planetName: planetName)
            cities.append(city)
            
            var spawnPoint: CGPoint?
            var isOverlapping = true
            while isOverlapping == true {
                spawnPoint = CGPoint(x: CGFloat.random(in: 0...1000), y: CGFloat.random(in: 300...700))
                if cityLocs != [] {
                    for loc in cityLocs {
                        if CGPointDistanceSquared(from: loc, to: spawnPoint!) > 22500 // 150^2, faster than doing sqrt, makes cities spawn at least 150 units apart
                        {isOverlapping = false}
                    }
                } else {isOverlapping = false}
            }
            
            let citySize = planetMap.generateCitySprite(loc: spawnPoint!)
            cityLocs.append(spawnPoint!)
            cityMapping.append(citySize)
        }
    }
    
    func generateAllCitySprites() {
        for cityLoc in cityLocs {
            cityMapping.append(planetMap.generateCitySprite(loc: cityLoc))
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
}


