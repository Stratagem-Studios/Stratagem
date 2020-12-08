import SpriteKit
import SceneKit

class Planet {
    var planetName: String!
    var owner: String!
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    
    // for map
    var cityLocs: [CGPoint] = []
    var unitTiles: [UIImage] = []
    
    //  can be changed to random later, should match cites.count
    let cityCount = 1
    
    /// loc on a 1 x 1, used for planet mapping
    var cityMapping: [CGRect] = []
    var planetMap = PlanetMap(size: CGSize(width: 1000, height: 1000))
    
    let planetSphere = SCNSphere.init(radius: 10)
    var planetNode: SCNNode?
    var planetLight: SCNNode?
    var cameraOrbit: SCNNode?
    
    init(planetName: String) {
        generatePlanetNode()
        generateNewCity(cityName: "e")
        self.planetName = planetName
    }
    
    func generateNewCity(cityName: String) -> City {
        let city = City()
        city.initCity(cityName: cityName)
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
        return city
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
    
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
}


