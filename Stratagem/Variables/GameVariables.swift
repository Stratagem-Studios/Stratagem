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
    
    var galaxy: Galaxy
        
    func generateGalaxy(){
        galaxy.generateNewGalaxy(gameType)
    }
    init(){galaxy = Galaxy()} /// generates our first galaxy. generateGalaxy can be executed again to create new galaxy
}

