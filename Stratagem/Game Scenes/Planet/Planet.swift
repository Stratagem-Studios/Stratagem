import SpriteKit

class Planet {
    var planetName: String!
    var owner: String!
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    var cityMapping = [
        CGRect(x: 353, y: 153, width: 167, height: 90),
        //CGRect(x: 353, y: 183, width: 144, height: 99),
        //CGRect(x: 392, y: 148, width: 142, height: 82)
    ]
    
    init(planetName: String) {
        self.planetName = planetName
    }
    
    func generateNewCity(cityName: String) -> [[Int]]? {
        let city = City()
        let terrain = city.initCity(cityName: cityName)
        cities.append(city)
        
        return terrain
    }
}
