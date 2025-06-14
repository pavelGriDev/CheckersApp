//
//  CheckersGameEngine.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 13.06.25.
//

import Foundation

final class CheckersGameEngine {

    func getNormalMoves(board: [[CheckerType?]], from position: BoardPosition) -> [BoardPosition] {
        guard let checker = board[position.row][position.col] else { return [] }
        
        var moves: [BoardPosition] = []
        let directions = getDirections(for: checker)
        
        for dir in directions {
            let newRow = position.row + dir.row
            let newCol = position.col + dir.col
            
            if newRow >= 0, newRow < 8, newCol >= 0, newCol < 8,
               board[newRow][newCol] == nil {
                moves.append(BoardPosition(row: newRow, col: newCol))
            }
        }
        
        return moves
    }
    
    func getForcedCaptures(board: [[CheckerType?]], from position: BoardPosition) -> [BoardPosition] {
        guard let checker = board[position.row][position.col] else { return [] }
        
        var captures: [BoardPosition] = []
        let directions = getDirections(for: checker, includeBackward: true)
        
        for dir in directions {
            let jumpRow = position.row + dir.row * 2
            let jumpCol = position.col + dir.col * 2
            
            guard jumpRow >= 0, jumpRow < 8, jumpCol >= 0, jumpCol < 8 else { continue }
            
            let midRow = position.row + dir.row
            let midCol = position.col + dir.col
            
            if let midChecker = board[midRow][midCol],
               isEnemy(checker, midChecker),
               board[jumpRow][jumpCol] == nil {
                captures.append(BoardPosition(row: jumpRow, col: jumpCol))
            }
        }
        
        return captures
    }
    
    private func getDirections(for checker: CheckerType, includeBackward: Bool = false) -> [(row: Int, col: Int)] {
            switch checker {
            case .black:
                return [(1, -1), (1, 1)]
            case .white:
                return [(-1, -1), (-1, 1)]
            default:
                return includeBackward
                ? [(1, 1), (1, -1), (-1, 1), (-1, -1)]
                : [(1, -1), (1, 1), (-1, -1), (-1, 1)]
            }
        }
        
        private func isEnemy(_ checker: CheckerType, _ other: CheckerType) -> Bool {
            switch (checker, other) {
            case (.black, .white), (.black, .whiteKing),
                 (.white, .black), (.white, .blackKing):
                return true
            default:
                return false
            }
        }
}
