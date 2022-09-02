//
//  BlindeGameState.swift
//  XO-game
//
//  Created by Илья Рехтин on 02.09.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class BlindeGameState: GameState {
    
    private(set) var isCompleted: Bool = false
    private(set) var endGame: Bool = false
    
    public let markViewPrototype: MarkView
    let player: Player
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
    }
    
    func addMove(at position: GameboardPosition) {
        
        log(.playerInput(player: player, position: position))
        
        guard let gameboardView = gameboardView, let gameboard = gameboard else {
            return
        }
        
        let moveCommand = MoveCommand(player: self.player,
                                      gameboard: gameboard,
                                      posotion: position,
                                      gameboardView: gameboardView)
        MoveInvoker.shared.addMoveCommand(for: self.player, moveCommand)
        
        switch self.player {
        case .first:
            self.isCompleted = MoveInvoker.shared.commandsForX.count == 5 ? true : false
        case .second:
            self.isCompleted = MoveInvoker.shared.commandsForO.count == 5 ? true : false
            self.endGame = MoveInvoker.shared.commandsForO.count == 5 ? true : false
        }
        
        if MoveInvoker.shared.commandsForO.count == 5 {
            MoveInvoker.shared.work()
        }
        

    }
}
