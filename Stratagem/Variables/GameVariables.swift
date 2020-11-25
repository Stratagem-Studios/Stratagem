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
    @Published var galaxyLayout: [PlanetLayout] = []
    
    @Published var selectedPlanet:PlanetView?
    @Published var selectedCity: CityView?
    
    init(gameType: GameTypes) {
        galaxy = GalaxyView()
        self.gameType = gameType
    }
}

struct PlanetLayout {
    var planet: PlanetView
    var cities: [CityLayout]
}

struct CityLayout {
    var city: CityView
    // This struct will hold the cities variable/stats classes
}


