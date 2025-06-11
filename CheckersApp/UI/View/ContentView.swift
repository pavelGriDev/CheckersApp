//
//  ContentView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ContentViewModel()
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)
    @State private var selectedCell: (row: Int, col: Int)? = nil
    var body: some View {
        VStack {
            ConnectionStateView(state: $vm.connectionState)
            
            Spacer()
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<64) { index in
                    let row = index / 8
                    let col = index % 8
                    let isDark = (row + col) % 2 != 0
                    
                    ZStack {
                        Rectangle()
                            .fill(isDark ? Color.brown : Color.white)
                        
                        if let checker = vm.board[row][col] {
                            Checker(type: checker)
                                .onTapGesture {
                                    if selectedCell == nil {
                                        selectedCell = (row, col)
                                    } else {
                                        // Попытка сделать ход
                                        moveSelected(from: selectedCell!, to: (row, col))
                                        selectedCell = nil
                                    }
                                }
                        } else if isDark {
                            // Пустая тёмная клетка — можно нажать для хода
                            Rectangle()
                                .opacity(0.001)
                                .onTapGesture {
                                    if let selected = selectedCell {
                                        moveSelected(from: selected, to: (row, col))
                                        selectedCell = nil
                                    }
                                }
                        }
                    }
                    .border(selectedCell?.row == row && selectedCell?.col == col ? Color.blue : Color.clear, width: 2)
                    .aspectRatio(1, contentMode: .fill)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 50)
            .aspectRatio(1, contentMode: .fit)
            
            Spacer()
            
            Button(action: vm.sendMessageAction, label: {
                Text("Send message")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.green)
                    .clipShape(Capsule())
            })
            .bold()
            .padding(.bottom, 15)
            
            HStack {
                Button(action: vm.connectAction, label: {
                    Text("Connect")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
                
                Button(action: vm.disconnectAction, label: {
                    Text("Disconnect")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.red)
                        .clipShape(Capsule())
                })
            }
            .foregroundStyle(.white)
        }
        .padding()
        .onAppear { vm.onAppear() }
    }
    
    private func moveSelected(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
           // TODO: Проверка правил хода
        vm.board[to.row][to.col] = vm.board[from.row][from.col]
        vm.board[from.row][from.col] = nil
       }
}

#Preview {
    ContentView()
}


enum CheckerType {
    case black, white
    case blackKing, whiteKing // Дамки
}

struct Checker: View {
    let type: CheckerType
    
    var body: some View {
        Circle()
            .fill(type == .black || type == .blackKing ? Color.black : Color.white)
            .overlay(
                Circle()
                    .stroke(type == .blackKing || type == .whiteKing ? Color.yellow : Color.clear, lineWidth: 3)
            )
            .padding(5)
    }
}
