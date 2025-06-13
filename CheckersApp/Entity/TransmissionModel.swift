//
//  TransmissionModel.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 13.06.25.
//

import Foundation

protocol Transmissible: Codable {
    var typeIdentifier: ModelType { get }
}

enum ModelType: String, Codable {
    case start
    case move
    case end
}

struct StartGame: Transmissible {
    let typeIdentifier: ModelType
    
    let playersColor: PlayersColor
}

struct GameMove: Transmissible {
    let typeIdentifier: ModelType
    
    let strokeNumber: Int
    let playersColor: PlayersColor
    let moves: [BoardPosition]
}

struct EndGame: Transmissible {
    let typeIdentifier: ModelType
}

// MARK: --

struct BoardPosition: Equatable, Codable {
    let row: Int
    let col: Int
}

enum PlayersColor: Hashable, Codable {
    case white
    case black
    case none
}
