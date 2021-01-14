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
    
    var screenSize = UIScreen.main.bounds
    
    // Updates the game
    var updater = Updater()
    
    // Holds the alert box
    var alertBox = AlertBoxView()
    
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
    
    func checkGameOver(){
        if isWinner(){
            Global.playerVariables.currentView = .WinScreenView
        }
        
        if isLoser(){
            Global.playerVariables.currentView = .LoseScreenView
        }
    }
    
    func isWinner() -> Bool {
        for planet in galaxy.planets{
            if planet.owner != Global.playerVariables.playerName{
                return false;
            }
        }
        return true;
    }
    
    func isLoser() -> Bool{
        let otherPlayername = galaxy.planets.first?.owner
        for planet in galaxy.planets{
            if planet.owner != otherPlayername{
                return false;
            }
        }
        return true;
    }
    
}

