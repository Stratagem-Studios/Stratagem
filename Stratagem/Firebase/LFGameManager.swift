// Mediates connection between StaticGameVariables <-> Firebase (realtime)

import Firebase
import SwiftUI

public struct LFGameManager {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func generateRandomGameCode() {
        let letters = "0123456789"
        var gameCode: String = ""
        gameCode = String((0..<4).map{ _ in letters.randomElement()! })
        
        // Check if code already exists
        let gameStatusRef = ref.child("games")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(gameCode) {
                generateRandomGameCode()
            } else {
                staticGameVariables.gameCode = gameCode
                self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(GameStates.PRE_LOBBY.rawValue)
                
                staticGameVariables.leaderName = playerVariables.playerName
                self.ref.child("games").child(gameCode).child("usernames").setValue([playerVariables.playerName])
                self.ref.child("games").child(gameCode).child("leader").setValue(playerVariables.playerName)
                self.ref.child("all_users").child(playerVariables.playerName).child("game_id").setValue(gameCode)
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(PlayerStates.LOBBY.rawValue)
                
                playerVariables.currentView = .CreateGameView
            }
        }
    }
    
    public func createGameWithCode(code: String) {
        self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(GameStates.LOBBY.rawValue)
        staticGameVariables.gameState = .LOBBY
        playerVariables.currentView = .GameLobbyView
    }
    
    public func joinGameWithCode(code: String) {
        // Check if game code exists
        let gameCodesRef = ref.child("games")
        gameCodesRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(code) {
                // Check if game is joinable
                let game_status = snapshot.childSnapshot(forPath: code).childSnapshot(forPath: "game_status").value as! String
                if game_status == GameStates.LOBBY.rawValue {
                    // Join game
                    self.ref.child("all_users").child(playerVariables.playerName).child("game_id").setValue(code)
                    self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(PlayerStates.LOBBY.rawValue)
                    
                    let gamePlayersRef = ref.child("games").child(code).child("usernames")
                    gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
                        var playerNames = [String]()
                        let enumerator = snapshot.children
                        while let rest = enumerator.nextObject() as? DataSnapshot {
                            playerNames.append(rest.value as! String)
                        }
                        playerNames.append(playerVariables.playerName)
                        gamePlayersRef.setValue(playerNames)
                        
                        staticGameVariables.gameCode = code
                        
                        Global.lfGameListener!.listenToAll()
                        playerVariables.currentView = .GameLobbyView
                    }
                } else {
                    playerVariables.errorMessage = "Game is in progress or hasn't been created yet"
                }
            } else {
                // Propagate error message popup
                playerVariables.errorMessage = "Please enter a valid 4 digit game code"
            }
        }
        
    }
    
    public func removePlayerFromGame(username: String) {
        ref.child("all_users").child(username).child("game_id").removeValue()
        self.ref.child("all_users").child(username).child("status").setValue(PlayerStates.TITLESCREEN.rawValue)
        
        // Remove from game
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            var playerNames = [String]()
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                playerNames.append(username.value as! String)
            }
            playerNames.remove(object: username)
            gamePlayersRef.setValue(playerNames)
        }
    }
    
    public func startGame() {
        if staticGameVariables.leaderName == playerVariables.playerName {
            // Player is the leader
            self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(GameStates.GAME.rawValue)
            let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
            gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
                let enumerator = snapshot.children
                while let username = enumerator.nextObject() as? DataSnapshot {
                    ref.child("all_users").child(username.value as! String).child("game_id").setValue(staticGameVariables.gameCode)
                    ref.child("all_users").child(username.value as! String).child("status").setValue(PlayerStates.GAME.rawValue)
                }
            }
        } else {
            playerVariables.errorMessage = "You're not the leader"
        }
    }
    
    /// Called for each player on game start to initalize their own planets/cities
    public func playerInitGame() {
        Global.setGames(gameVars: GameVariables())
        
        let gameRef = self.ref.child("games/\(staticGameVariables.gameCode)")
        if staticGameVariables.leaderName == playerVariables.playerName {
            // If leader, generate the galaxy and all the planets
            let galaxy = Galaxy()
            galaxy.generateNewGalaxy()
            
            var planetOwneri = 0
            let planetOwners = Array(0..<galaxy.planets.count).choose(staticGameVariables.playerNames.count)
            for (i, planet) in galaxy.planets.enumerated() {
                // Set owner, giving each player 1 random planet
                if planetOwners.contains(i) {
                    gameRef.child("planets/\(planet.planetName!)/owner").setValue(staticGameVariables.playerNames[planetOwneri])
                    planetOwneri += 1
                } else {
                    gameRef.child("planets/\(planet.planetName!)/owner").setValue("***NIL***")
                }
                // Set city mapping
                var cityMappingStrings: [String] = []
                for cityMapping in planet.cityMapping {
                    cityMappingStrings.append(NSCoder.string(for: cityMapping))
                }
                gameRef.child("planets/\(planet.planetName!)/cityMapping").setValue(cityMappingStrings)
            }
            
            // Set galaxy vars
            gameRef.child("galaxy/planet_locs").setValue(["(0, 0)"])
        }
        
        // After leader generates galaxy and planets, fetch changes and generate own city. Own a random planet/city
        gameRef.child("galaxy/planet_locs").observeSingleEvent(of: .childAdded, with: { _ in
            // Fetch data
            var planets: [Planet] = []
            var ownedPlanetNames: [String] = []
            gameRef.child("planets").observeSingleEvent(of: .value, with: { snapshot in
                let enumerator = snapshot.children
                
                while let planetSnapshot = enumerator.nextObject() as? DataSnapshot {
                    let planet = Planet(planetName: planetSnapshot.key)
                    planets.append(planet)

                    if let planetSnapshotValue = planetSnapshot.value as? Dictionary<String, Any> {
                        planet.owner = planetSnapshotValue["owner"] as? String
                        
                        let cityMappingsString = planetSnapshotValue["cityMapping"] as! [Any]
                        var cityMappings: [CGRect] = []
                        for cityMapping in cityMappingsString {
                            cityMappings.append(NSCoder.cgRect(for: cityMapping as! String))
                        }
                        planet.cityMapping = cityMappings
                        
                        // Generate city on owned planet
                        if planet.owner == playerVariables.playerName {
                            let potentialCityNames = getListOfNames(fileName: "city_names")
                            gameRef.child("cities").observeSingleEvent(of: .value, with: { snapshot in
                                while true {
                                    let cityName = potentialCityNames?.randomElement()
                                    if !snapshot.hasChild(cityName!) {
                                        let city = planet.generateNewCity(cityName: cityName!)
                                        city.owner = playerVariables.playerName
                                        
                                        gameRef.child("/cities/\(city.cityName!)/owner").setValue(playerVariables.playerName)
                                        Global.hfGamePusher.uploadCityTerrain(cityName: city.cityName!, cityTerrainInt: city.cityTerrainInt)
                                        ownedPlanetNames.append(planet.planetName)
                                        
                                        
                                        // Init galaxy
                                        let galaxy = Galaxy()
                                        galaxy.planets = planets
                                        galaxy.ownedPlanetNames.append(contentsOf: ownedPlanetNames)
                                        Global.gameVars.galaxy = galaxy
                                        Global.gameVars.selectedPlanet = planet
                                        Global.gameVars.ownedCities.append(city)
                                        
                                        playerVariables.currentView = .GameView
                                        break
                                    }
                                }
                            })
                        }
                    }
                }
            })
        })
    }
    
    public func removeGame() {
        // Remove all players from game
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                ref.child("all_users").child(username.value as! String).child("game_id").removeValue()
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(PlayerStates.TITLESCREEN.rawValue)
            }
            
            ref.child("games").child(staticGameVariables.gameCode).removeValue()
            playerVariables.currentView = .TitleScreenView
        }
    }
    
    public func detectAndRemoveDeadGames() {
        var allGameCodes: [String] = []
        let gameRef = ref.child("games")
        gameRef.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let game = enumerator.nextObject() as? DataSnapshot {
                allGameCodes.append(game.key)
            }
        })
        
        let allUsersRef = ref.child("all_users")
        allUsersRef.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                let value = username.value as! Dictionary<String, Any>
                if let game_id = value["game_id"] {
                    if value["status"] as! String != "OFFLINE" {
                        // 1+ active player in game
                        allGameCodes.remove(object: game_id as! String)
                    }
                }
            }
            
            for removeGameCode in allGameCodes {
                ref.child("games").child(removeGameCode).removeValue()
            }
            
            Global.playerManager!.fetchName()
        }
    }
}

public func getListOfNames(fileName: String) -> [String]? {
    var cityNames: [String]?
    
    do {
        // This solution assumes  you've got the file in your bundle
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt"){
            let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            cityNames = data.components(separatedBy: "\n")
            
        }
    } catch let err as NSError {
        // do something with Error
        print(err)
    }
    return cityNames
}

