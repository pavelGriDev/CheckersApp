//
//  CheckersBoardView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct BoardPosition: Equatable {
    let row: Int
    let col: Int
}

struct CheckersBoardView: View {
    @StateObject private var game = CheckersGameEngine()
    
    @State private var selectedCell: BoardPosition? = nil
    @State private var animatedPosition: BoardPosition? = nil
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<64, id: \.self) { index in
                    let row = index / 8
                    let col = index % 8
                    let isDarkSquare = (row + col) % 2 != 0
                    
                    ZStack {
                        // Клетка доски
                        Rectangle()
                            .fill(isDarkSquare ? Color.brown : Color.white)
                        
                        
                        // Шашка (если есть)
                        if let checker = game.board[row][col] {
                            CheckerView(type: checker)
                                .onTapGesture {
                                    print("Checker - row: \(row), col: \(col)")
                                }
                        } else {
                            // Невидимая кнопка для тапов (должна покрывать ВСЮ клетку)
                            Rectangle()
                                .opacity(0.001)
                                .onTapGesture {
                                    print("Empty - row: \(row), col: \(col)")
                                }
                        }
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .border(
                        selectedCell == BoardPosition(row: row, col: col) ?
                        Color.blue : Color.clear,
                        width: 2
                    )
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
        .backgroundColor()
    }
    
    private func moveSelected(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        // TODO: Проверка правил хода
        game.board[to.row][to.col] = game.board[from.row][from.col]
        game.board[from.row][from.col] = nil
    }
}

#Preview {
    CheckersBoardView()
}
