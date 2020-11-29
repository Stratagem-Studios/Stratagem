// Stores variables for high-frequency game updates

import Combine
import SceneKit
import SpriteKit

enum GameViewLevel {
    case GALAXY, PLANET, CITY
}

enum GameTypes {
    case STANDARD, PLANETRUSH
}

struct Global {
    static var gameVars:GameVariables? = nil

    static func setGames(gameVars: GameVariables) {
        Global.gameVars = gameVars
    }
}

class GameVariables {
    // Used for setup
    var gameType: GameTypes = GameTypes.STANDARD
    
    // Directly determines display
    var selectedPlanet: PlanetView = PlanetView(planetID: 0)
    var selectedCity: City?
    
    var galaxy: GalaxyView
    var galaxyLayout: [PlanetLayout] = []
    
    var galaxyScene: SKScene?
    
    func generateGalaxy(){
        var numPlanets: Int
        switch gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        for i in 0..<numPlanets {
            galaxyLayout.append(PlanetLayout(planetID: i, planet: PlanetView(planetID: i)))
            galaxyLayout[i].planetNode = galaxyLayout[i].planet.planetNode
        }
    }
    init(){galaxy = GalaxyView()} /// generates our first galaxy. generateGalaxy can be executed again to create new galaxy
}

struct PlanetLayout {
    var planetID: Int!
    var planet: PlanetView!
    var planetNode: SCNNode?
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [City] = []
    let cityMapping = [
        CGRect(x: 353, y: 153, width: 167, height: 90),
        CGRect(x: 353, y: 183, width: 144, height: 99),
        CGRect(x: 392, y: 148, width: 142, height: 82)
    ]
    
    init(planetID: Int, planet: PlanetView) {
        self.planet = planet
        self.planetID = planetID
        for i in 0..<cityMapping.count {
            let city = City()
            city.initCity(cityName: "City Name")
            cities.append(city)
        }
    }
}

