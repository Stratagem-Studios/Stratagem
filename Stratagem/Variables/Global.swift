struct Global {
    static var playerManager: PlayerManager! = nil
    static var lfGameManager: LFGameManager! = nil
    static var lfGameListener: LFGameListener! = nil
    static var gameVars: GameVariables! = nil

    static func initManagers(playerVariables: PlayerVariables, staticGameVariables: StaticGameVariables) {
        Global.playerManager = PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        
        Global.lfGameManager = LFGameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
        
        Global.lfGameListener = LFGameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
    }
    static func setGames(gameVars: GameVariables) {
        Global.gameVars = gameVars
    }
}
