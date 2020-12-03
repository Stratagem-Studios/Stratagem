import SpriteKit
import SceneKit

class Planet {
    var planetName: String!
    var owner: String!
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    
    // for map
    /// loc on a 1000 x 1000
    var cityLocs: [CGRect] = []
    var citySprites: [UIImage] = []
    var planetMap: [UIImage] = []
    var unitTiles: [UIImage] = []
    
    //  can be changed to random later, should match cites.count
    let cityCount = 1
    
    /// loc on a 1 x 1, used for planet mapping
    var cityMapping: [CGRect] = []

    
    init(planetName: String) {
        /// Earth terrain
        self.planetName = planetName
        planetMap.append(UIImage(named: "BasicMap")!)
        
        /// adds the cities
        for _ in 0..<cityCount {
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            let city = UIImage(named: "NeutralCity")!
            var isOverlapping = true
            while isOverlapping == true {
                x = CGFloat(Int.random(in: 0...1000))
                y = CGFloat(Int.random(in: 300...700))
                if cityLocs != [] {
                    for loc in cityLocs {
                        if CGPointDistanceSquared(from: loc.points[0], to: CGPoint(x: x, y: y)) > 22500 // 150^2, faster than doing sqrt
                        {isOverlapping = false}
                    }
                } else {isOverlapping = false}
            }
            citySprites.append(city)
            cityLocs.append(CGRect(x: x, y: y,width: 150,height: 150))
            cityMapping.append(CGRect(x: x/planetMap[0].size.width, y: y/planetMap[0].size.height, width: 250.0/planetMap[0].size.width, height: 150.0/planetMap[0].size.height))
        }
        
        
    }
    
    func generateNewCity(cityName: String) -> City {
        let city = City()
        city.initCity(cityName: cityName)
        cities.append(city)
        
        return city
    }
    
    func generatePlanetMap() -> UIImage {
        let size = CGSize(width: 1000, height: 1000)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        for image in planetMap {
            image.draw(in: areaSize)
        }
        UIImage(named: "EnemyCity")!.draw(in: cityMapping[0])
        for i in 0..<citySprites.count {
            citySprites[i].draw(in: cityLocs[i])
        }
        let finalMap: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return finalMap
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
}

