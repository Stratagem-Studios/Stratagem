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
        Global.setGames(gameVars: GameVariables())
        
        // While in the lobby, the leader asynchonously generates the galaxy, planets, and cities
        DispatchQueue.global(qos: .background).async {
            let gameRef = self.ref.child("games/\(staticGameVariables.gameCode)")
            let galaxy = Galaxy()
            galaxy.generateNewGalaxy()
            Global.gameVars.galaxy = galaxy
            
            // Upload galaxy to firebase
            
            // Upload planets to firebase
            for planet in galaxy.planets {
                // Set owner
                gameRef.child("planets/\(planet.planetName!)/owner").setValue("***NIL***")
                
                // Set cityLocs
                var cityLocsStrings: [String] = []
                for cityLoc in planet.cityLocs {
                    cityLocsStrings.append(NSCoder.string(for: cityLoc))
                }
                gameRef.child("planets/\(planet.planetName!)/cityLocs").setValue(cityLocsStrings)
                
                // Upload cities to firebase
                for city in planet.cities {
                    gameRef.child("cities/\(city.cityName!)/owner").setValue("***NIL***")
                    gameRef.child("cities/\(city.cityName!)/planetName").setValue(city.planetName)
                    
                    Global.hfGamePusher.uploadCityTerrain(cityName: city.cityName!, cityTerrainInt: city.cityTerrainInt!)
                    
                    // Resources
                    Global.hfGamePusher.uploadResources(cityName: city.cityName!, name: "resources", resources: city.resources)
                    Global.hfGamePusher.uploadResources(cityName: city.cityName!, name: "resourcesCap", resources: city.resourcesCap)
                }
            }
            
            Global.gameVars.finishedGeneratingGalaxy = true
        }
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
        // Check if player is the leader
        if staticGameVariables.leaderName == playerVariables.playerName {
            let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
            gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
                let enumerator = snapshot.children
                while let username = enumerator.nextObject() as? DataSnapshot {
                    ref.child("all_users").child(username.value as! String).child("game_id").setValue(staticGameVariables.gameCode)
                    ref.child("all_users").child(username.value as! String).child("status").setValue(PlayerStates.GAME.rawValue)
                }
                
                playerInitGame()
            }
        } else {
            playerVariables.errorMessage = "You're not the leader"
        }
    }
    
    /// Called by the leader to start the game
    public func playerInitGame() {
        let gameRef = self.ref.child("games/\(staticGameVariables.gameCode)")
        // If leader, assign all players a planet/city
        if playerVariables.playerName == staticGameVariables.leaderName {
            gameRef.child("usernames").observeSingleEvent(of: .value) { snapshot in
                var playerNames = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    playerNames.append(rest.value as! String)
                }
                
                let selectedPlanets = Global.gameVars.galaxy.planets.choose(playerNames.count)
                for (i, selectedPlanet) in selectedPlanets.enumerated() {
                    gameRef.child("planets/\(selectedPlanet.planetName!)/owner").setValue(playerNames[i])
                    
                    gameRef.child("cities/\(selectedPlanet.cities[0].cityName!)/owner").setValue(playerNames[i])
                    
                    //gameRef.child("players/\(playerNames[i])/ownedPlanets").setValue([selectedPlanet.planetName!])
                    
                    //gameRef.child("players/\(playerNames[i])/ownedCities").setValue([selectedPlanet.cities[0].cityName!])
                }
                gameRef.child("game_status").setValue(GameStates.GAME.rawValue)
            }
        }
    }
    
    public func playerGameStarted() {
        // After leader generates galaxy and planets, fetch initial galaxy state. First update of gameVars
        let gameRef = self.ref.child("games/\(staticGameVariables.gameCode)")
        Global.setGames(gameVars: GameVariables())
        
        // Fetch planets
        var planets: [Planet] = []
        gameRef.child("planets").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            
            while let planetSnapshot = enumerator.nextObject() as? DataSnapshot {
                let planet = Planet(planetName: planetSnapshot.key)
                planets.append(planet)
                
                if let planetSnapshotValue = planetSnapshot.value as? Dictionary<String, Any> {
                    planet.owner = planetSnapshotValue["owner"] as? String
                    
                    let cityLocsStrings = planetSnapshotValue["cityLocs"] as! [Any]
                    var cityLocs: [CGPoint] = []
                    for cityLoc in cityLocsStrings {
                        cityLocs.append(NSCoder.cgPoint(for: cityLoc as! String))
                    }
                    //===========================================================
                    // cityMappings adds one city to the mapping section that was not generated per planet.generateCity, and does not add the sprite or a city class to planet.cities
                    // cityMappings changes the cityMapping to incorrectly reflect thier positions
                    
                    planet.cityLocs = cityLocs
                    planet.generateAllCitySprites()
                    
                    //===========================================================
                    // Generate all cities on owned planet
                    /*
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
                     }
                     }
                     })
                     }
                     */
                }
            }
            
            // Fetch cities
            gameRef.child("cities").observeSingleEvent(of: .value, with: { citiesSnapshot in
                let enumerator = citiesSnapshot.children
                
                var ownedPlanet: Planet?
                var ownedCity: City?
                while let citySnapshot = enumerator.nextObject() as? DataSnapshot {
                    if let citySnapshotDict = citySnapshot.value as? Dictionary<String, Any> {
                        let city = City()
                        let planetName = citySnapshotDict["planetName"]! as! String
                        city.initCity(cityName: citySnapshot.key, planetName: planetName, owner: citySnapshotDict["owner"]! as? String, terrain: citySnapshotDict["cityTerrainFlattened"]! as? [[Int]])
                        
                        let planet = planets.filter({$0.planetName == planetName}).first!
                        planet.cities.append(city)
                        if citySnapshotDict["owner"]! as! String == playerVariables.playerName {
                            ownedCity = city
                            ownedPlanet = planet
                        }
                    }
                }
                
                // Init galaxy
                let galaxy = Galaxy()
                galaxy.planets = planets
                Global.gameVars.galaxy = galaxy
                Global.gameVars.selectedPlanet = ownedPlanet!
                Global.gameVars.selectedCity = ownedCity!
                
                playerVariables.currentView = .GameView
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

