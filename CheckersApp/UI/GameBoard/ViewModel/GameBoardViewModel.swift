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
    
    @Published var possibleMoves: [BoardPosition] = []
    @Published var selectedCell: BoardPosition? = nil
    
    private let isHost: Bool
    private var isMyTurn: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.currentTurnStatus = self.isMyTurn ? .yourTurn : .waiting
            }
        }
    }
    
    private var turnMoves: [BoardPosition] = []
    private var capturedPositions: [BoardPosition] = []
    private var hasCapture: Bool = false
    
    private let mcpManager: MPCManager
    private let codableManager: CodableManager
    private let gameEngine: CheckersGameEngine
    
    init(
        color: PlayersColor,
        isHost: Bool,
        mcpManager: MPCManager = MultipeerSessionManager(),
        codableManager: CodableManager = CodableManagerImp(),
        gameEngine: CheckersGameEngine = CheckersGameEngine()
    ) {
        self.playersColor = color
        self.isHost = isHost
        self.mcpManager = mcpManager
        self.codableManager = codableManager
        self.gameEngine = gameEngine
        
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
        
        guard isHost else { return }
        mcpManager.connect()
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
        case let gameMove as GameMove:
            updateBoard(with: gameMove)
        case let endModel as EndGame:
            break
        default:
            break
        }
    }
    
    private func updateBoard(with model: GameMove) {
        let path = model.path
        guard path.count >= 2 else { return }

        let fromPositions = path.enumerated().compactMap { $0.offset.isMultiple(of: 2) ? $0.element : nil }
        let toPositions = path.enumerated().compactMap { !$0.offset.isMultiple(of: 2) ? $0.element : nil }
        
        let maxIndex = fromPositions.count
        
        for (index, (from, to)) in zip(fromPositions, toPositions).enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.applyCheckerMove(from: from, to: to)
                
                if index + 1 == maxIndex {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        for checkerPosition in model.captured {
                            self.removeChecker(at: checkerPosition)
                        }
                        self.isMyTurn = true
                        // нужно проверить всю доску на обязательные ходы
                        // или проверять позицию последнего хода на обязательные ходы
                    }
                }
            }
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
        
        let forcedCapture = gameEngine.getForcedCaptures(board: board, from: position)
        
        if forcedCapture.isEmpty {
            hasCapture = false
            possibleMoves = gameEngine.getNormalMoves(board: board, from: position)
        } else {
            hasCapture = true
            possibleMoves = forcedCapture
        }
    }
    
    func tryMove(to position: BoardPosition) {
        guard isMyTurn else { return }
        guard let selectedCell else { return }
        guard possibleMoves.contains(position) else { return }
                
        // сделать ход
        applyCheckerMove(from: selectedCell, to: position)
        appendMove(from: selectedCell, to: position)
        
        // временное решение для удаление шашки
        if let midPosition = getMidPosition(from: selectedCell, to: position) {
            board[midPosition.row][midPosition.col] = nil
            capturedPositions.append(midPosition)
        }
        
        self.selectedCell = nil
        possibleMoves = []
        
        if hasCapture {
            let forcedCapture = gameEngine.getForcedCaptures(board: board, from: position)
            if forcedCapture.isEmpty {
                giveMove()
                hasCapture = false
            } else {
                self.selectedCell = position
                possibleMoves = forcedCapture
            }
        } else {
            giveMove()
            hasCapture = false
        }
    }
    
    private func giveMove() {
        let gameMove = GameMove(
            typeIdentifier: .move,
            playersColor: playersColor,
            path: turnMoves,
            captured: capturedPositions
        )
        
        do {
            let data = try codableManager.encoded(from: gameMove)
            try mcpManager.send(data)
            isMyTurn = false
            turnMoves = []
            capturedPositions = []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getMidPosition(from: BoardPosition, to: BoardPosition) -> BoardPosition? {
        if (from.row + to.row) % 2 == 0 {
            let midRow = (from.row + to.row) / 2
            let midCol = (from.col + to.col) / 2
            return BoardPosition(row: midRow, col: midCol)
        } else {
            return nil
        }
    }
}

// MARK: Helps

extension CheckersBoardViewModel {
    private func applyCheckerMove(from: BoardPosition, to: BoardPosition) {
        board[to.row][to.col] = board[from.row][from.col]
        removeChecker(at: from)
    }
    
    private func removeChecker(at: BoardPosition) {
        board[at.row][at.col] = nil
    }
    
    private func appendMove(from: BoardPosition, to: BoardPosition) {
        turnMoves += [from, to]
    }
}
