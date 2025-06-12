//
//  MainButton.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct MainButton: View {
    private let height: CGFloat = 50
    
    let title: String
    let color: Color
    let textColor: Color
    let action: () -> Void
    
    init(
        title: String,
        color: Color,
        textColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundStyle(textColor)
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(color)
                .clipShape(Capsule())
        })
    }
}
