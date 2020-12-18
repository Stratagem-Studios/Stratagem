// Stores variables for high-frequency game updates

import SceneKit
import SpriteKit
import Combine
import SKTiled
import SwiftUI

enum GameViewLevel: String {
    case GALAXY, PLANET, CITY
}

enum GameTypes: String {
    case STANDARD, PLANETRUSH
}

public enum ResourceTypes: String, CaseIterable, Codable {
    case CREDITS, METAL, POPULATION
}

class GameVariables {
    /// Set to true if player is leader and they have finished generating galaxy
    var finishedGeneratingGalaxy = false
    
    // Used for setup
    var gameType: GameTypes = GameTypes.STANDARD
    
    // Directly determines display
    var selectedPlanet: Planet?
    var selectedCity: City?
    var currentTilemap: SKTilemap?
    var cityScene: CityScene! = nil
    
    var galaxy: Galaxy!
    
    // only here for now, should be migrated
    var screenSize = UIScreen.main.bounds
    
    // Updates the game
    var updater = Updater()
    
    /// Set this to true to update HudNode manually in CityView
    var shouldUpdateCityHudNode = false
    
    func update(deltaTime: CGFloat){
        // Update the galaxy
        galaxy.update(dt: deltaTime)
        
        // Update population numbers per city
        for planet in Global.gameVars.galaxy.planets.filter({$0.owner == Global.playerVariables.playerName}) {
            planet.update(deltaTime: deltaTime)
        }
    }
    
}

