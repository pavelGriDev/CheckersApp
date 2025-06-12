//
//  ContentViewModel.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation

final class CheckersBoardViewModel: ObservableObject {
    @Published var board: [[CheckerType?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    
    private var playersColor: PlayersColor = .none
    
    private let mcpManager: MPCManager
    
    init(mcpManager: MPCManager = MultipeerSessionManager() ) {
        self.mcpManager = mcpManager
        
        setupInitialBoard()
    }
    
    func onAppear() {
//        mcpManager.setup()
    }
    
    func onDisappear() {
        
    }
    
    func set(_ playersColor: PlayersColor) {
        self.playersColor = playersColor
    }
    
    private func setupInitialBoard() {
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
    }
}

