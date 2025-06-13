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
    private let codableManager: CodableManager
    
    init(
        mcpManager: MPCManager = MultipeerSessionManager(),
        codableManager: CodableManager = CodableManagerImp()
    ) {
        self.mcpManager = mcpManager
        self.codableManager = codableManager
        
        self.mcpManager.stateHandler = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state { // нужно потом сделать лайбл
                case .notConnected:
                    print("notConnected.")
                case .connecting:
                    print("connecting...")
                case .connected:
                    print("connected")
                    self.sendSetupMessage()
                default:
                    fatalError()
                }
            }
        }
        
        setupInitialBoard()
    }
    
    func onAppear() {
        mcpManager.setup()

        if playersColor != .none {
            mcpManager.connect()
        }
    }
    
    func onDisappear() {
        mcpManager.disconnect()
    }
    
    func set(_ playersColor: PlayersColor) {
        self.playersColor = playersColor
    }
    
    func sendSetupMessage() {
        guard playersColor != .none else { return }
        // нужно передать первоначальные настройки
        // цвет противника
        // указать кто начинает игру
        
//        mcpManager.send("Привет мир")
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

//struct StartGameMessage: Codable {
//    let playersColor: PlayersColor
//}
//
//struct PlayerMoveMessage: Codable {
//    let from: GameMove
//    let to: GameMove
//    let captured: [GameMove]
//    let becameKing: Bool
//}
