// Stores variables for high-frequency game updates

import SceneKit
import SpriteKit
import Combine
import SwiftUI

enum GameViewLevel: String {
    case GALAXY, PLANET, CITY
}

enum GameTypes: String {
    case STANDARD, PLANETRUSH
}

enum ResourceTypes: String {
    case CREDITS, METAL, POPULATION
}

class GameVariables {
    // Resources
    var population: Int = 1000
    var credits: Int = 1000
    var metal: Int = 50
    
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

