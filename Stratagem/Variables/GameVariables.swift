// Stores variables for high-frequency game updates

import Combine

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

class GameVariables: ObservableObject {
    
    // Sets up the gameResourceList to contain all resource values
    var gameResources: [resourceStatsList] = []
    

    init() {
        for a in resourceDefaultStats {
            gameResources.append(resourceStatsList(type: a[0] as! resourceTypes, timerMax: a[1] as! Double, timerLive: a[2] as! Double))
        }
    }
}

struct resourceStatsList {
    var type: resourceTypes
    var timerMax: Double
    var timerLive: Double
    var quantity = 0
    
    
}
