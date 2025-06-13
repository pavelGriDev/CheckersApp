//
//  CheckersGameEngine.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 13.06.25.
//

import Foundation

final class CheckersGameEngine {
    func possibleMoves(board: [[CheckerType?]],_ move: BoardPosition) -> [BoardPosition] {
        let directions: [(Int, Int)]
        let checker = board[move.row][move.col]
        
        switch checker {
        case .black:
            // вниз по диагонали
            directions = [(1, -1), (1, 1)]
        case .white:
            // вверх по диагонал
            directions = [(-1, -1), (-1, 1)]
        default:
            return [] // пока не обрабатываем дамок
        }
        
        var moves: [BoardPosition] = []
        
        for (dr, dc) in directions {
            let newRow = move.row + dr
            let newCol = move.col + dc

            // проверка что row и col не выходят за граници
            guard newRow >= 0, newRow < 8,
                  newCol >= 0, newCol < 8 else {
                continue
            }

            if board[newRow][newCol] == nil {
                moves.append(BoardPosition(row: newRow, col: newCol))
            }
        }
        
        return moves
    }
}
