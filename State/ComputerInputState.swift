//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Илья Рехтин on 29.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation


class ComputerInputState: GameState {
    
    private(set) var isCompleted: Bool = false

    public let markViewPrototype: MarkView
    var player: Player = .second
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        gameViewController?.winnerLabel.isHidden = true
        guard let gameboard = gameboard else {return}
        gameboardView?.generateAIMove(gameboard: gameboard)
    }
    
    func addMove(at position: GameboardPosition) {
        log(.playerInput(player: player, position: position))
        
        guard let gameboardView = gameboardView,
              gameboardView.canPlaceMarkView(at: position) else {
            return
        }
        gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
    
    

    
    
    
    
    
    
    
    
}

