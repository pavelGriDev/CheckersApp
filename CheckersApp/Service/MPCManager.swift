//
//  MPCManager.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation
import MultipeerConnectivity

protocol MPCManager {
    
}

final class MultipeerSessionManager: NSObject {
    private var session: MCSession?
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?
    
    private let serviceType = "checkers"
    
    var stateHandler: ((String) -> Void)?
    var messageHandler: ((String) -> Void)?
    
    func setup() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
        startBrowser()
    }
    
    func connect() {
        stopBrowsingAndAdvertising()
        startAdvertiser()
    }
    
    func disconnect() {
        session?.connectedPeers.forEach { session?.cancelConnectPeer($0) }
        stopBrowsingAndAdvertising()
        startBrowser()
    }
    
    func send(_ message: String) {
        sendMessage("Hey! \(message). From \(UIDevice.current.name)")
    }
    
    private func startAdvertiser() {
        advertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    private func startBrowser() {
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    private func stopBrowsingAndAdvertising() {
        if let browser {
            browser.stopBrowsingForPeers()
        }
        if let advertiser {
            advertiser.stopAdvertisingPeer()
        }
        session?.disconnect()
    }
    
    func sendMessage(_ message: String) {
        guard let peers = session?.connectedPeers,
              let data = try? JSONEncoder().encode(message) else { return }
        do {
            try session?.send(data, toPeers: peers, with: .reliable)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: MCSessionDelegate

extension MultipeerSessionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            stateHandler?("Not Connected.")
        case .connecting:
            stateHandler?("connecting...")
        case .connected:
            stateHandler?("Connected.")
        @unknown default:
            fatalError() // show error
        }
    }
    // когда приходит сообщение от другога пира
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(String.self, from: data) else { return }
        messageHandler?(message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) { }
}

// MARK: MCNearbyServiceAdvertiserDelegate

extension MultipeerSessionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}

// MARK: MCNearbyServiceBrowserDelegate

extension MultipeerSessionManager: MCNearbyServiceBrowserDelegate {
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String : String]?
    ) {
        guard let session else { return }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
}
