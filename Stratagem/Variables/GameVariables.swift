// Stores variables for high-frequency game updates

import Combine
import SceneKit
import ObjectiveC

enum GameViewLevel {
    case GALAXY, PLANET, CITY
}

enum GameTypes {
    case STANDARD, PLANETRUSH
}

class GameVariables: ObservableObject {
    // Used for setup
    @Published var gameType: GameTypes = GameTypes.STANDARD
    
    // Directly determines display
    @Published var selectedPlanet:PlanetView = PlanetView(planetID: 0)
    @Published var selectedCity: CityView = CityView()
    @Published var currentGameViewLevel = GameViewLevel.PLANET
    
    @Published var galaxy: GalaxyView
    @Published var galaxyLayout: [PlanetLayout] = []
    
    func generateGalaxy(){
        var numPlanets: Int
        switch gameType {
        case .STANDARD:
            numPlanets = 7
        default:
            numPlanets = 5
        }
        for i in 0...numPlanets { galaxyLayout.append(PlanetLayout(planetID: i, planet: PlanetView(planetID: i))) }
    }
    
    init(){galaxy = GalaxyView()} /// generates our first galaxy. generateGalaxy can be executed again to create new galaxy
}

struct PlanetLayout {
    var planetID: Int!
    var planet: PlanetView!
    var planetNode: SCNNode?
    
    // Later when city count/position is random these will need to be procedurally generated
    var cities: [CityLayout] = []
    let cityMapping = [
        CGRect(x: 353, y: 153, width: 167, height: 90),
        CGRect(x: 353, y: 183, width: 144, height: 99),
        CGRect(x: 392, y: 148, width: 142, height: 82)
    ]
    
    init(planetID: Int, planet: PlanetView) {
        self.planet = planet
        self.planetID = planetID
        for i in 0...cityMapping.count {
            cities.append(CityLayout())
        }
    }
}

struct CityLayout {
    var city: CityView
    // This struct will hold the cities variable/stats classes
    
    init() {
        city = CityView()
    }
}

