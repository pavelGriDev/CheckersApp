//
//  CodableManager.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 13.06.25.
//

import Foundation

protocol CodableManager {
    func encoded(from model: Transmissible) throws -> Data
    func decode(from data: Data) throws -> Transmissible
}

final class CodableManagerImp: CodableManager {
    
    func encoded(from model: Transmissible) throws -> Data {
        let encoder = JSONEncoder()
        
        // Для читаемости
        encoder.outputFormatting = .prettyPrinted
        
        switch model {
        case let startModel as StartGame:
            return try encoder.encode(startModel)
            
        case let gameMoveModel as GameMove:
            return try encoder.encode(gameMoveModel)
            
        case let endModel as EndGame:
            return try encoder.encode(endModel)
            
        default:
            throw EncodingError.invalidValue(
                model,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Unknown model type: \(type(of: model))"
                )
            )
        }
    }
    
    func decode(from data: Data) throws -> Transmissible {
        let decoder = JSONDecoder()
        
        struct ModelTypeContainer: Decodable {
            let typeIdentifier: ModelType
        }
        
        let typeContainer = try decoder.decode(ModelTypeContainer.self, from: data)
        
        switch typeContainer.typeIdentifier {
        case .start:
            return try decoder.decode(StartGame.self, from: data)
        case .move:
            return try decoder.decode(GameMove.self, from: data)
        case .end:
            return try decoder.decode(EndGame.self, from: data)
        }
    }
}
