// Stores variables for high-frequency game updates

import SceneKit
import SpriteKit
import Combine
import SwiftUI

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
    var selectedPlanet: Planet?
    var selectedCity: City?
    
    var galaxy: Galaxy!
    
    // only here for now, should be migrated
    var screenSize = UIScreen.main.bounds
    
    // Updates the game
    var updater = Updater()
    
    
    func update(deltaTime: Float){
    }
    
}

