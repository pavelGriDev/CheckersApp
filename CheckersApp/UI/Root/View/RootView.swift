//
//  RootView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

enum Router: Hashable {
    case gameBoard
}

struct RootView: View {
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                
                Spacer()
                
                MainButton(title: "Start", color: .blue) {
                    path.append(Router.gameBoard)
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: Router.self) { value in
                switch value {
                case .gameBoard:
                    CheckersBoardView()
                }
            }
        }
    }
}

#Preview {
    RootView()
}
