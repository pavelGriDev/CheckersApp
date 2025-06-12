//
//  RootView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

enum Router: Hashable {
    case gameBoard(PlayersColor)
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
                        path.append(Router.gameBoard(.none))
                    }
                }
            }
            .padding()
            .backgroundColor()
            .navigationDestination(for: Router.self) { value in
                switch value {
                case .gameBoard(let selectedColor ):
                    CheckersBoardView(playersColor: selectedColor)
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

