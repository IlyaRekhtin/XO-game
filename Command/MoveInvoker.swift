//
//  MoveInvoker.swift
//  XO-game
//
//  Created by Илья Рехтин on 02.09.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class MoveInvoker {
    
    static let shared = MoveInvoker()
    
    
    var commandsForX = [MoveCommand]()
    var commandsForO = [MoveCommand]()
    
    func addMoveCommand(for player: Player,_ command: MoveCommand) {
        switch player {
        case .first:
            self.commandsForX.append(command)
        case .second:
            self.commandsForO.append(command)
        }
    }
    
    func work() {
        
        commandsForX.forEach {$0.execute()}
        commandsForO.forEach {$0.execute()}
        
        
        
        
        
        
        self.commandsForX.removeAll()
        self.commandsForO.removeAll()
    }
}
