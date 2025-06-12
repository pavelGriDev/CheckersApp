//
//  MatchSetup.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 12.06.25.
//

import SwiftUI

struct MatchSetup: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Please,\nChoose a color.")
                .multilineTextAlignment(.center)
                .font(.title)
            
            Spacer()
            
            VStack(spacing: 20) {
                MainButton(title: "White", color: .white, textColor: .black) {
                    path.append(Router.gameBoard(.white))
                }
                
                MainButton(title: "Black", color: .black) {
                    path.append(Router.gameBoard(.black))
                }
            }
        }
        .padding()
        .backgroundColor()
    }
}

#Preview {
    MatchSetup(path: .constant(.init()))
}
