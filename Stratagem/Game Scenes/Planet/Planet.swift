import SpriteKit
import SceneKit

class Planet {
    var planetName: String! // Firebase
    var owner: String! // Firebase
    
    var cities: [City] = []
    var cityTransfers: [CityTransfers] = []
    
    // for map
    var cityLocs: [CGPoint] = []
    var unitTiles: [UIImage] = []
    
    /// loc on a 1 x 1, used for planet mapping
    var cityMapping: [CGRect] = [] // Firebase
    var planetMap = PlanetMap(size: CGSize(width: 1000, height: 1000))
    
    let planetSphere = SCNSphere.init(radius: 10)
    var planetNode: SCNNode?
    var planetLight: SCNNode?
    var cameraOrbit: SCNNode?
    
    init(planetName: String) {
        generatePlanetNode()
        self.planetName = planetName
    }
    
    func update(deltaTime: CGFloat) {
        for city in cities.filter({$0.owner == Global.playerVariables.playerName}) {
            city.update(deltaTime: deltaTime)
        }
        for transfer in cityTransfers {
            
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
                spawnPoint = CGPoint(x: CGFloat.random(in: 100...900), y: CGFloat.random(in: 400...600))
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
    func generatePlanetNode() {
        planetNode = SCNNode(geometry: planetSphere)
        
        planetSphere.firstMaterial?.diffuse.contents = planetMap
        
        cameraOrbit = SCNNode()
        cameraOrbit!.camera = SCNCamera()
        
        cameraOrbit!.position = SCNVector3(0,0,22)
        
        // Make the sphere
        
        // add an ambient light to the scene
        planetLight = SCNNode()
        planetLight!.light = SCNLight()
        planetLight!.light!.type = .ambient
        planetLight!.light!.color = UIColor.gray
    }
    
    func updatePlanet(){
        planetSphere.firstMaterial?.diffuse.contents = planetMap
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


