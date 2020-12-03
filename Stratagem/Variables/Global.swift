struct Global {
    static var playerManager: PlayerManager! = nil
    static var lfGameManager: LFGameManager! = nil
    static var lfGameListener: LFGameListener! = nil
    static var hfGamePusher: HFGamePusher! = nil
    
    static var playerVariables: PlayerVariables! = nil
    static var staticGameVariables: StaticGameVariables! = nil

    static var gameVars: GameVariables! = nil

    static func initManagers(playerVariables: PlayerVariables, staticGameVariables: StaticGameVariables) {
        Global.playerManager = PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        Global.lfGameManager = LFGameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        Global.lfGameListener = LFGameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        Global.hfGamePusher = HFGamePusher(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        
        self.playerVariables = playerVariables
        self.staticGameVariables = staticGameVariables
    }
    static func setGames(gameVars: GameVariables) {
        Global.gameVars = gameVars
    }
}
