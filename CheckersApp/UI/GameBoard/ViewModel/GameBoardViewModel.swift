//
//  ContentViewModel.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation

enum TurnStatus: String {
    case yourTurn = "Your turn"
    case waiting = "Please wait..."
}

final class CheckersBoardViewModel: ObservableObject {
    @Published var board: [[CheckerType?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    
    @Published var connectState: String = ""
    @Published var currentTurnStatus: TurnStatus = .waiting
    
    var playersColor: PlayersColor
    
    
    @Published var selectedCell: BoardPosition? = nil
    
    private let isHost: Bool
    private var isMyTurn: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.currentTurnStatus = self.isMyTurn ? .yourTurn : .waiting
            }
        }
    }
    
    private let mcpManager: MPCManager
    private let codableManager: CodableManager
    
    init(
        color: PlayersColor,
        isHost: Bool,
        mcpManager: MPCManager = MultipeerSessionManager(),
        codableManager: CodableManager = CodableManagerImp()
    ) {
        self.playersColor = color
        self.isHost = isHost
        self.mcpManager = mcpManager
        self.codableManager = codableManager
        
        self.mcpManager.stateHandler = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notConnected:
                    self.connectState = "notConnected."
                case .connecting:
                    self.connectState = "connecting..."
                case .connected:
                    self.connectState = "connected"
                    self.sendStartMessage()
                default:
                    fatalError()
                }
            }
        }
        
        self.mcpManager.messageHandler = { [weak self] data in
            guard let self else { return }
            messageHandler(data)
        }
    }
    
    func onAppear() {
        mcpManager.setup()

        if isHost {
            mcpManager.connect()
        }
    }
    
    func onDisappear() {
        mcpManager.disconnect()
    }
    
    func sendStartMessage() {
        guard isHost else { return }
        
        let opponentsColor: PlayersColor = playersColor == .white ? .black : .white
        let startModel = StartGame(typeIdentifier: .start, playersColor: opponentsColor)
        
        do {
            let data = try codableManager.encoded(from: startModel)
            try mcpManager.send(data)
            startSetup(color: playersColor)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func messageHandler(_ data: Data) {
        let result: Transmissible
        
        do {
            result = try codableManager.decode(from: data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        switch result {
        case let startModel as StartGame:
            startSetup(color: startModel.playersColor)
        case let moveModel as GameMove:
            break
        case let endModel as EndGame:
            break
        default:
            break
        }
    }
}

// MARK: Start game

extension CheckersBoardViewModel {
    private func startSetup(color: PlayersColor) {
        DispatchQueue.main.async {
            self.setupInitialBoard()
            self.playersColor = color
            self.isMyTurn = self.playersColor == .white
            self.playersColor = color
            self.objectWillChange.send()
        }
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

// MARK: Game

extension CheckersBoardViewModel {
    func selectChecker(at position: BoardPosition) {
        guard isMyTurn else { return }
        guard let checker = board[position.row][position.col] else { return }
        guard checker.owner == playersColor else { return }
        
        selectedCell = position
        // нужно показать допустимые ходы
    }
    
    func makeMove(at position: BoardPosition) {
        guard isMyTurn else { return }
        guard let from = selectedCell else { return }
        
        // vm.board[row][col] = vm.board[from.row][from.col]
        // vm.board[from.row][from.col] = nil
        // selectedCell = nil
    }
}
