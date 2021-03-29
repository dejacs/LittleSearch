//
//  ApiSearch.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Alamofire
import Foundation

class ApiSearch {
    static func fetch<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping(Result<T, APIError>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            return
        }
        AF.request(url, method: endpoint.method, parameters: endpoint.params).responseJSON { (result) in
            DispatchQueue.main.async {
                guard let data = result.data else {
                    completion(.failure(.genericError))
                    return
                }
                GenericDataHandler<T>.handleSingleResponse(data: data, completion: completion)
            }
        }
    }
    
    static func fetchArray<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping(Result<[T], APIError>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            return
        }
        AF.request(url, method: endpoint.method, parameters: endpoint.params).responseJSON { (result) in
            DispatchQueue.main.async {
                guard let data = result.data else {
                    completion(.failure(.genericError))
                    return
                }
                GenericDataHandler<T>.handleArrayResponse(data: data, completion: completion)
            }
        }
    }
}
