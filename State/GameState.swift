//
//  GameState.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 12.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

protocol GameState {
    var isCompleted: Bool { get }
    
    func begin()
    func addMove(at position: GameboardPosition)
}
