//
//  Api.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Alamofire
import Foundation

enum StatusCode {
    static let success = 200
}

enum APIError: Error {
    case genericError
}

class Api<T: Decodable> {
    /**
     * Fetch any provided endpoint returning a json.
     *
     * A generic request that returns a json.
     * 
     *  - Parameter endpoint: An object that should implement EndpointProtocol
     *  - Parameter completion: A block called when operation has been completed. This block has no return value and takes the Result as its parameter. In case of error while parsing the data, it will call the failure completion. When success it will call the generic handler so it will convert to the specific object.
     */
    func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<T, APIError>) -> Void) {
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
    
    /**
     * Fetch any provided endpoint returning an array.
     *
     * A generic request that returns an array.
     *
     *  - Parameter endpoint: An object that should implement EndpointProtocol
     *  - Parameter completion: A block called when operation has been completed. This block has no return value and takes the Result as its parameter. In case of error while parsing the data, it will call the failure completion. When success it will call the generic handler so it will convert to the specific array of object.
     */
    func fetchArray(endpoint: EndpointProtocol, completion: @escaping(Result<[T], APIError>) -> Void) {
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
