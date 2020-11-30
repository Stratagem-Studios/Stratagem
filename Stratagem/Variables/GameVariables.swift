// Stores variables for high-frequency game updates

import SceneKit
import SpriteKit

enum GameViewLevel {
    case GALAXY, PLANET, CITY
}

enum GameTypes {
    case STANDARD, PLANETRUSH
}

class GameVariables {
    // Used for setup
    var gameType: GameTypes = GameTypes.STANDARD
    
    // Directly determines display
    var selectedPlanet: Int = 0
    var selectedCity: City?
    
    var galaxy: Galaxy?
    
    // only here for now, should be migrated
    var screenSize: CGRect?
}

