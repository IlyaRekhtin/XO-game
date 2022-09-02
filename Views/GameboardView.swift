//
//  GameBoardView.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

// MARK: - GameboardView
public class GameboardView: UIView {
    
    // MARK: - Public Properties
    
    public var onSelectPosition: ((GameboardPosition) -> Void)?
    
    public private(set) var markViewForPosition: [GameboardPosition: MarkView] = [:]
    
    // MARK: - Constants
    
    internal struct Constants {
        static let lineColor: UIColor = .black
        static let lineWidth: CGFloat = 7
    }
    
    // MARK: - Private Properties
    
    private var calculatedColumnWidth: CGFloat {
        return bounds.width / CGFloat(GameboardSize.columns)
    }
    private var calculatedRowHeight: CGFloat {
        return bounds.height / CGFloat(GameboardSize.rows)
    }
    
    // MARK: - Public
    
    public func clear() {
        
        for (_, markView) in markViewForPosition {
            markView.removeFromSuperview()
        }
        markViewForPosition = [:]
    }
    
    public func clear(_ position: GameboardPosition) {
        self.markViewForPosition[position]?.removeFromSuperview()
        self.markViewForPosition[position] = nil
    }
    
    public func canPlaceMarkView(at position: GameboardPosition) -> Bool {
        
        return markViewForPosition[position] == nil
    }
    
    public func placeMarkView(_ markView: MarkView, at position: GameboardPosition) {
        
        guard self.canPlaceMarkView(at: position) else { return }
        updateFrame(for: markView, at: position)
        markViewForPosition[position] = markView
        addSubview(markView)
    }
    
    public func removeMarkView(at position: GameboardPosition) {
       
        guard let markView = markViewForPosition[position] else {
            return
        }
        markViewForPosition[position] = nil
        markView.removeFromSuperview()
    }
    
    // MARK: - UIView
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        Constants.lineColor.setStroke()
        drawColumnLines(for: rect)
        drawRowLines(for: rect)
    }
    
    // MARK: - Touch Handling
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchLocation = touches.first?.location(in: self) else { return }
        let position = GameboardPosition(column: determineColumn(for: touchLocation),
                                         row: determineRow(for: touchLocation))
        onSelectPosition?(position)
    }
    
    public func generateAIMove(gameboard: Gameboard) {
       getMoveForAi(for: gameboard)
    }
    
    // MARK: - UI
    
    private func drawColumnLines(for rect: CGRect) {
        
        let columnWidth = self.calculatedColumnWidth
        for i in 1 ..< GameboardSize.columns {
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: rect.minX + CGFloat(i) * columnWidth,
                                      y: rect.minY))
            linePath.addLine(to: CGPoint(x: rect.minX + CGFloat(i) * columnWidth,
                                         y: rect.minY + rect.height))
            linePath.lineWidth = Constants.lineWidth
            linePath.stroke()
        }
    }
    
    private func drawRowLines(for rect: CGRect) {
        
        let rowHeight = self.calculatedRowHeight
        for i in 1 ..< GameboardSize.rows {
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: rect.minX, y: rect.minY + CGFloat(i) * rowHeight))
            linePath.addLine(to: CGPoint(x: rect.minX + rect.width, y: rect.minY + CGFloat(i) * rowHeight))
            linePath.lineWidth = Constants.lineWidth
            linePath.stroke()
        }
    }
    
    // MARK: - Private
    
    private func determineColumn(for touchLocation: CGPoint) -> Int {
        
        let columnWidth = self.calculatedColumnWidth
        let lastColumn = GameboardSize.columns - 1
        for i in (0 ..< lastColumn) {
            let xMin = CGFloat(i) * columnWidth
            let xMax = CGFloat(i + 1) * columnWidth
            if (xMin ..< xMax).contains(touchLocation.x) {
                return i
            }
        }
        return lastColumn
    }
    
    private func determineRow(for touchLocation: CGPoint) -> Int {
        
        let rowHeight = self.calculatedRowHeight
        let lastRow = GameboardSize.rows - 1
        for i in (0 ..< lastRow) {
            let yMin = CGFloat(i) * rowHeight
            let yMax = CGFloat(i + 1) * rowHeight
            if (yMin ..< yMax).contains(touchLocation.y) {
                return i
            }
        }
        return lastRow
    }
    
    private func updateFrame(for markView: MarkView, at position: GameboardPosition) {
        
        let columnWidth = self.calculatedColumnWidth
        let rowHeight = self.calculatedRowHeight
        markView.frame = CGRect(x: CGFloat(position.column) * columnWidth,
                                y: CGFloat(position.row) * rowHeight,
                                width: columnWidth,
                                height: rowHeight).insetBy(dx: 0.5 * Constants.lineWidth,
                                                           dy: 0.5 * Constants.lineWidth)
    }
}


//MARK: AI
private extension GameboardView {
    
    
    func getMoveForAi(for gameboard: Gameboard) {
        // получаем все комбинации игры
        let allWinCombination = Referee(gameboard: gameboard).winningCombinations
        // получаем комбинации для х и о
        let combinationX = getCombinationForX(allWinCombination, gameboard)
        let combinationO = getCombinationForO(allWinCombination, gameboard)
        // получаем комбинации для х и о с 2 завершенными клетками
        let winCombinationForO = (willComplete(combinationO, for: .second, gameboard))
        let winCombinationForX = (willComplete(combinationX, for: .first, gameboard))
        // если есть выйгрышная комбинация для о мы ее заканчиваем
        if !winCombinationForO.isEmpty {
            for position in winCombinationForO {
                if canPlaceMarkView(at: position) {
                    onSelectPosition?(position)
                    break
                }
            }
        // иначе проверяем выйгрышную комбинацию для х и закрываем ему ход
        } else if !winCombinationForX.isEmpty {
            for position in winCombinationForX {
                if canPlaceMarkView(at: position) {
                    onSelectPosition?(position)
                    break
                }
            }
        // смотрим есть ли начатые комбинации о если есть продолжаем
        } else if !combinationO.isEmpty {
            for position in combinationO.first! {
                if canPlaceMarkView(at: position) {
                    onSelectPosition?(position)
                    break
                }
            }
        // если нет начатых начимнаем свободную комбинацию
        } else {
           let combination = allWinCombination.filter({ combination in
                for position in combination {
                    if gameboard.contains(player: .first, at: position) {
                        return true
                    }
                }
                return false
            })
            let index = Int.random(in: 0..<combination.count)
            for position in combination[index] {
                if canPlaceMarkView(at: position) {
                    onSelectPosition?(position)
                    break
                }
            }
        }
    }
    
    func getCombinationForX(_ allWinCombination: [[GameboardPosition]], _ gameboard: Gameboard) -> [[GameboardPosition]]{
        let combinationX = allWinCombination.filter { combination in
            for position in combination {
                if gameboard.contains(player: .first, at: position) {
                    return true
                }
            }
            return false
        }.filter { combination in
            for position in combination {
                guard !gameboard.contains(player: .second, at: position) else {
                    return false
                }
            }
            return true
        }
        return combinationX
    }
    
    func getCombinationForO(_ allWinCombination: [[GameboardPosition]], _ gameboard: Gameboard) -> [[GameboardPosition]]{
        let combinationO = allWinCombination.filter { combination in
            for position in combination{
                if gameboard.contains(player: .second, at: position) {
                return true
                }
            }
            return false
        }.filter { combination in
            for position in combination {
                guard !gameboard.contains(player: .first, at: position) else {
                    return false
                }
            }
            return true
        }
        return combinationO
    }
    
    private func willComplete(_ combinations: [[GameboardPosition]], for player: Player, _ gameboard: Gameboard) -> [GameboardPosition] {
        var counter = 0
        for combination in combinations {
            for position in combination {
                if gameboard.contains(player: player, at: position) {
                    counter += 1
                }
            }
            if counter >= 2 {
                counter = 0
               return combination
            }
            counter = 0
        }
        return []
    }
}
