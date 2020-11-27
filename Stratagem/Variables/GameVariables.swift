// Stores variables for high-frequency game updates

import Combine
import SceneKit
import ObjectiveC

enum GameViewLevel {
    case galaxy, planet, city
}

enum GameTypes {
    case standard, planetRush
}

class GameVariables: ObservableObject {
    // Used for setup
    @Published var gameType: GameTypes = GameTypes.standard
    
    // Directly determines display
    @Published var selectedPlanet:PlanetView = PlanetView(planetID: 0)
    @Published var selectedCity: CityView = CityView()
    @Published var currentGameViewLevel = GameViewLevel.city
    
    @Published var galaxy: GalaxyView
    @Published var galaxyLayout: [PlanetLayout] = []
    
    func generateGalaxy(){
        var numPlanets: Int
        switch gameType {
        case .standard:
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
    var planetNode = SCNNode()
    var cities: [CityLayout] = []
}

struct CityLayout {
    var city: CityView
    // This struct will hold the cities variable/stats classes
}

