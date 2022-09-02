//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    var gameVariants: GameVariants = .pvp
    private lazy var referee = Referee(gameboard: gameboard)
    private let gameboard = Gameboard()
    
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else {
                return
            }
            self.currentState.addMove(at: position)
            
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirstState() {
        switch self.gameVariants {
        case .pvp:
            let player = Player.first
            currentState = PlayerInputState(player: player,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView,
                                            markViewPrototype: player.markViewPrototype)
        case .pve:
            let player = Player.first
            currentState = PlayerInputState(player: player,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView,
                                            markViewPrototype: player.markViewPrototype)
        case .blinde:
            let player = Player.first
            currentState = BlindeGameState(player: player,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView,
                                            markViewPrototype: player.markViewPrototype)
        }
       
        
    }
    
    private func goToNextState() {
        
        switch self.gameVariants {
        case .pvp:
            if let winner = referee.determineWinner() {
                currentState = GameFinishedState(winner: winner, gameViewController: self)
                return
            }
            
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                currentState = PlayerInputState(player: player,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype)
            }
        case .pve:
            if let winner = referee.determineWinner() {
                currentState = GameFinishedState(winner: winner, gameViewController: self)
                return
            }
            
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                currentState = ComputerInputState(player: player,
                                                  gameViewController: self,
                                                  gameboard: gameboard,
                                                  gameboardView: gameboardView,
                                                  markViewPrototype: player.markViewPrototype)
            } else if let playerInputState = currentState as? ComputerInputState {
                let player = playerInputState.player.next
                currentState = PlayerInputState(player: player,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype)
            }
            
        case .blinde:
            
           
            if let blindeGameState = currentState as? BlindeGameState {
                if blindeGameState.endGame {
                    print(gameboard.printPlayer())
                    guard let winner = referee.determineWinner() else {return}
                    currentState = GameFinishedState(winner: winner, gameViewController: self)
                    return
                }
                let player = blindeGameState.player.next
                currentState = BlindeGameState(player: player,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype)
            }
        }
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        self.gameboard.clear()
        self.gameboardView.clear()
        goToFirstState()
        log(.restartGame)
    }
}

