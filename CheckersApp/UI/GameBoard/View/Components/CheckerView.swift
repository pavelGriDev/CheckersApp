//
//  CheckerView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct CheckerView: View {
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
