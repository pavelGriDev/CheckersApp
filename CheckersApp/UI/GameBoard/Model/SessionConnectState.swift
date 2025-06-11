//
//  ConnectState.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation

enum SessionConnectState {
    case connected
    case connecting
    case notConnected
    case none
    
    var title: String {
        switch self {
        case .connected:
            "Online"
        case .connecting:
            "Connecting"
        case .notConnected:
            "Not Connected"
        case .none:
            ""
        }
    }
}
