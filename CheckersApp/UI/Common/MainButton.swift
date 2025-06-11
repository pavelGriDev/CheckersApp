//
//  MainButton.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct MainButton: View {
    private let height: CGFloat = 40
    
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(color)
                .clipShape(Capsule())
        })
    }
}
