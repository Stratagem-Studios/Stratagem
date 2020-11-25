// Stores variables for high-frequency game updates

import Combine
import ObjectiveC

enum GameViewLevel {
    case galaxy, planet, city
}

enum GameTypes {
    case standard, planetRush
}

class GameVariables: ObservableObject {
    @Published var gameType: GameTypes = GameTypes.standard
    @Published var currentGameViewLevel = GameViewLevel.galaxy
    @Published var galaxy: GalaxyView?
    @Published var selectedPlanet:[PlanetView]?
    @Published var selectedCity: [CityView]?
    
    init(gameType: GameTypes) {
        galaxy = GalaxyView()
        self.gameType = gameType
        
        
// All of the below is for resource generation and may be moved to a new class
        for a in resourceDefaultStats {
            gameResources.append(resourceStatsList(type: a[0] as! resourceTypes, timerMax: a[1] as! Double, timerLive: a[2] as! Double))
        }
    }
    // Sets up the gameResourceList to contain all resource values
    var gameResources: [resourceStatsList] = []
}
// enum keeps track of all possible materials
// Not sure if nessasary
enum resourceTypes {
    case metal, gold
}

// Materials follow this pattern
// [enum, timerMax, timerLive, actual count]
var resourceDefaultStats = [
    [resourceTypes.metal, 2.0, 2.0, 0],
    [resourceTypes.gold, 7.0, 7.0, 0]
]

struct resourceStatsList {
    var type: resourceTypes
    var timerMax: Double
    var timerLive: Double
    var quantity = 0
    
    
}

struct planetLayout {
    var planet: PlanetView
    var cities: [CityView]
}

struct cityLayout {
    var city: CityView
    // This struct will hold the cities variable classes
}


