//
//  RootView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

enum Router: Hashable {
    case gameBoard(color: PlayersColor, isHost: Bool)
    case matchSetup
}

struct RootView: View {
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                Text("Checkers")
                    .multilineTextAlignment(.center)
                    .font(.title)
                Spacer()
                
                VStack(spacing: 20) {
                    MainButton(
                        title: "Create",
                        color: .brown,
                        
                    ) {
                        path.append(Router.matchSetup)
                    }
                    MainButton(
                        title: "Join",
                        color: .white,
                        textColor: .black
                    ) {
                        path.append(Router.gameBoard(color: .none, isHost: false))
                    }
                }
            }
            .padding()
            .backgroundColor()
            .navigationDestination(for: Router.self) { value in
                switch value {
                case let .gameBoard(selectedColor, value):
                    CheckersBoardView(color: selectedColor, isHost: value)
                case .matchSetup:
                    MatchSetup(path: $path)
                }
            }
        }
    }
}

#Preview {
    RootView()
}

