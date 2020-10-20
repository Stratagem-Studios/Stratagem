//
//  Variables.swift
//  Stratagem
//
//  Created by 90306997 on 10/20/20.
//

// This file contains all the game variables locally
// Should consist of mostly structs
// Needs to be implemented

import Foundation


class Variables {

    var gameResources = GameResources()
    var gameResourceTimers = GameResourceTimers()
    var gameRescourceTimersLive = GameRescourceTimersLive()
}

struct GameResources {
    var metal = 0
    var gold = 0
}

struct GameResourceTimers {
    var metal = 2.0
    var gold = 4.0
}

struct GameRescourceTimersLive {
    var metal = 2.0
    var gold = 4.0
}

