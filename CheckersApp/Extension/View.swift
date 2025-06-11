//
//  View.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

extension View {
    func backgroundColor(_ color: Color = .gray.opacity(0.3)) -> some View {
        ZStack {
            color.ignoresSafeArea()
            
            self
        }
    }
}
