//
//  ContentViewModel.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation

final class ContentViewModel: ObservableObject {
    
    @Published var message = "_"
    @Published var connectionState: SessionConnectState = .none
    
    private let multipeerManager = MultipeerSessionManager()
    
    init() {
        self.multipeerManager.stateHandler = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .notConnected:
                    self?.connectionState = .notConnected
                case .connecting:
                    self?.connectionState = .connecting
                case .connected:
                    self?.connectionState = .connected
                @unknown default:
                    self?.connectionState = .none
                }
            }
        }
        
        self.multipeerManager.messageHandler = { [weak self] message in
            DispatchQueue.main.async {
                self?.message = message
            }
        }
    }
    
    func onAppear() {
        multipeerManager.setup()
    }
    
    func connectAction() {
        multipeerManager.connect()
    }
    
    func disconnectAction() {
        multipeerManager.disconnect()
    }
    
    func sendMessageAction() {
        multipeerManager.send("chupacabra")
    }
    
}
