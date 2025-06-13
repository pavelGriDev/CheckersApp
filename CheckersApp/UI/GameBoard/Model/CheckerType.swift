//
//  CheckerType.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import Foundation

enum CheckerType {
    case black
    case white
    case blackKing
    case whiteKing
    
    var owner: PlayersColor {
            switch self {
            case .black, .blackKing:
                return .black
            case .white, .whiteKing:
                return .white
            }
        }
}

