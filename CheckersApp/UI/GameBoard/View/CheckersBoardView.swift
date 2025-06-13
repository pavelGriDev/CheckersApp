//
//  CheckersBoardView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct CheckersBoardView: View {
    
    @StateObject private var vm: CheckersBoardViewModel
    
    init(color: PlayersColor, isHost: Bool) {
        _vm = StateObject(wrappedValue: CheckersBoardViewModel(color: color, isHost: isHost))
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("State: \(vm.connectState)")
                        .padding(.bottom, 10)
                    Text("\(vm.currentTurnStatus.rawValue)")
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<64, id: \.self) { index in
                    let row = index / 8
                    let col = index % 8
                    let isDarkSquare = (row + col) % 2 != 0
                    
                    ZStack {
                        // Клетка доски
                        Rectangle()
                            .fill(isDarkSquare ? Color.brown : Color.white)
                        
                        highlightMoves(row: row, col: col)
                        
                        if let checker = vm.board[row][col] {
                            CheckerView(type: checker)
                                .onTapGesture {
                                    vm.selectChecker(at: BoardPosition(row: row, col: col))
                                    print("Checker - row: \(row), col: \(col)")
                                }
                        } else {
                            Rectangle()
                                .opacity(0.001)
                                .onTapGesture {
                                    print("Empty - row: \(row), col: \(col)")
                                    vm.tryMove(to: BoardPosition(row: row, col: col))
                                }
                        }
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .border(
                        vm.selectedCell == BoardPosition(row: row, col: col) ?
                        Color.blue : Color.clear,
                        width: 2
                    )
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(vm.playersColor == .white ? 0 : 180))
        }
        .padding()
        .backgroundColor()
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisappear() }
    }
}

#Preview {
    CheckersBoardView(color: .white, isHost: true)
}

extension CheckersBoardView {
    @ViewBuilder
    func highlightMoves(row: Int, col: Int) -> some View {
        if vm.possibleMoves.contains(where: { $0.row == row && $0.col == col }) {
            Circle()
                .fill(Color.green.opacity(0.4))
                .padding(8)
        }
    }
}
