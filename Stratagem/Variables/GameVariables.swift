// Stores variables for high-frequency game updates

import Combine

enum GameViewLevel {
    case galaxy, planet, city
}

enum GameTypes {
    case standard, planetRush
}

class GameVariables: ObservableObject {
    @Published var currentGameViewLevel = GameViewLevel.galaxy
    @Published var galaxy: GalaxyView?
    @Published var planets:[PlanetView]?
    
    init() {
        
        
        
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
