//
//  CheckersGameEngineTest.swift
//  CheckersAppTests
//
//  Created by Pavel Gritskov on 13.06.25.
//

import Testing
@testable import CheckersApp

struct CheckersGameEngineTest {

    @Test func selectedRow5Col2() async throws {
        let move = BoardPosition(row: 5, col: 2)
        let sut = CheckersGameEngine()
        
        let result = sut.possibleMoves(board: createStartBoard(), move)
        
        let expected: [BoardPosition] = [
            .init(row: 4, col: 1),
            .init(row: 4, col: 3)
        ]
        
        #expect(result == expected)
    }
    
    @Test func selectedRow5Col0() async throws {
        let move = BoardPosition(row: 5, col: 0)
        let sut = CheckersGameEngine()
        
        let result = sut.possibleMoves(board: createStartBoard(), move)
        
        let expected: [BoardPosition] = [
            .init(row: 4, col: 1)
        ]
        
        #expect(result == expected)
    }
    
    @Test func selectedRow5Col4() async throws {
        let move = BoardPosition(row: 5, col: 4)
        let sut = CheckersGameEngine()
        
        let result = sut.possibleMoves(board: createStartBoard(), move)
        
        let expected: [BoardPosition] = [
            .init(row: 4, col: 3),
            .init(row: 4, col: 5)
        ]
        
        #expect(result == expected)
    }
    
    @Test func selectedRow2Col1() async throws {
        let move = BoardPosition(row: 2, col: 1)
        let sut = CheckersGameEngine()
        
        let result = sut.possibleMoves(board: createStartBoard(), move)
        
        let expected: [BoardPosition] = [
            .init(row: 3, col: 0),
            .init(row: 3, col: 2)
        ]
        
        #expect(result == expected)
    }
    
    @Test func selectedRow2Col7() async throws {
        let move = BoardPosition(row: 2, col: 7)
        let sut = CheckersGameEngine()
        
        let result = sut.possibleMoves(board: createStartBoard(), move)
        
        let expected: [BoardPosition] = [
            .init(row: 3, col: 6)
        ]
        
        #expect(result == expected)
    }
    
    
    
    
    func createStartBoard() -> [[CheckerType?]] {
        var board: [[CheckerType?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        
        // Чёрные шашки (игрок снизу)
        for row in 0..<3 {
            for col in 0..<8 where (row + col) % 2 != 0 {
                board[row][col] = .black
            }
        }
        
        // Белые шашки (игрок сверху)
        for row in 5..<8 {
            for col in 0..<8 where (row + col) % 2 != 0 {
                board[row][col] = .white
            }
        }
        
        return board
    }

}
