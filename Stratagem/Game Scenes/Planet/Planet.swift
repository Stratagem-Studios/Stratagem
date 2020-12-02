import SpriteKit

class Planet {
    var planetName: String!
    var owner: String!
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    var planetMap: [UIImage] = []
    var unitTiles: [UIImage] = []
    
    var cityMapping = [
        CGRect(x: 0.705, y: 0.431, width: 0.145, height: 0.139)
        //CGRect(x: 353, y: 183, width: 144, height: 99),
        //CGRect(x: 392, y: 148, width: 142, height: 82)
    ]
    
    init(planetName: String) {
        self.planetName = planetName
        planetMap.append(UIImage(named: "Planet")!)
        planetMap.append(UIImage(named: "Galaxy")!)
    }
    
    func generateNewCity(cityName: String) -> [[Int]]? {
        let city = City()
        let terrain = city.initCity(cityName: cityName)
        cities.append(city)
        
        return terrain
    }
    
    func generatePlanetMap() -> UIImage {
        let size = CGSize(width: 1000, height: 1000)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        for image in planetMap {
            image.draw(in: areaSize)
        }
        let finalMap: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return finalMap
    }
}

