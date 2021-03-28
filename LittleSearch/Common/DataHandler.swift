//
//  DataHandler.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Foundation

protocol DataHandlerProtocol {
    associatedtype Item: Decodable
    static func handleSingleResponse(data: Data, completion: @escaping(Result<Item, APIError>) -> Void)
    static func handleArrayResponse(data: Data, completion: @escaping(Result<[Item], APIError>) -> Void)
}

class GenericDataHandler<T: Decodable>: DataHandlerProtocol {
    typealias Item = T
    
    static func handleSingleResponse(data: Data, completion: @escaping(Result<Item, APIError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let response = try decoder.decode(Item.self, from: data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
    
    static func handleArrayResponse(data: Data, completion: @escaping(Result<[Item], APIError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let response = try decoder.decode([Item].self, from: data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
}
