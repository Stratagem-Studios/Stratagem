// Stores variables for high-frequency game updates

import Combine

// enum keeps track of all possible materials
// Not sure if nessasary
enum resourceTypes {
    case metal, gold
}

// Materials follow this pattern
// [enum, cooldownMax, timerLive, actual count]
var resourceDefaultStats = [
    [resourceTypes.metal, 2.0, 2.0, 0],
    [resourceTypes.gold, 7.0, 7.0, 0]
]

class GameVariables: ObservableObject {
    
    // Sets up the gameResourceList to contain all resource values
    var gameResources: [resourceStatsList] = []
<<<<<<< HEAD:GameVariables.swift
    @Published var currentView: String
    
    var username: String?
    
    @Published var currentGameState: gameStates
    @Published var gameCode: String
    

=======
    
>>>>>>> upstream/master:Stratagem/Variables/GameVariables.swift
    init() {
        for a in resourceDefaultStats {
            gameResources.append(resourceStatsList(resourceType: a[0] as! resourceTypes, resourceMaxTimer: a[1] as! Double, resourceLiveTimer: a[2] as! Double))
        }
    }
}

struct resourceStatsList {
    var resourceType: resourceTypes
    var resourceMaxTimer: Double
    var resourceLiveTimer: Double
    var resourceQuantity = 0
    
    
}
