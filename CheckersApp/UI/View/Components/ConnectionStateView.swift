//
//  ConnectionStateView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct ConnectionStateView: View {
    @Binding var state: SessionConnectState
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(state.title)
                .foregroundStyle(style)
        }
    }
    
    private var style: some ShapeStyle {
        switch state {
        case .connected:
            Color.green
        case .connecting:
            Color.blue
        default:
            Color.gray
        }
    }
}
