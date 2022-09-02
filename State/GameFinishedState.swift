//
//  GameFinishedState.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 12.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class GameFinishedState: GameState {
    var isCompleted: Bool = false
    let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    
    init(winner: Player?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    func begin() {
        log(.gameFinished(winner: winner))
        
        gameViewController?.winnerLabel.isHidden = false
        
        if let winner = winner {
            gameViewController?.winnerLabel.text = winnerName(from: winner) + "win"
        } else {
            gameViewController?.winnerLabel.text = "tie"
        }
        
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    func addMove(at position: GameboardPosition) { }
    
    private func winnerName(from winner: Player) -> String {
        
        return winner == .first ? "1st player": "2nd player"
    }
}
