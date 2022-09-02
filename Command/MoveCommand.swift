//
//  MoveCommand.swift
//  XO-game
//
//  Created by Илья Рехтин on 02.09.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation
import UIKit

class MoveCommand {
    
    var player: Player
    var gameboard: Gameboard
    var position: GameboardPosition
    var gameboardView: GameboardView
    
    init( player: Player, gameboard: Gameboard, posotion: GameboardPosition, gameboardView: GameboardView) {
        self.player = player
        self.gameboard = gameboard
        self.position = posotion
        self.gameboardView = gameboardView
    }
    
    func execute() {
    
        if gameboardView.canPlaceMarkView(at: position) {
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(player.markViewPrototype.copy(), at: position)
        } else {
            gameboard.clear(position)
            gameboardView.clear(position)
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(player.markViewPrototype.copy(), at: position)
        }
        
    }
    
}
