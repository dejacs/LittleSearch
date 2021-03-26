//
//  ProductDetailsService.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

protocol ProductDetailsServicing {
    func fetchProductDetails(productId: String, completion: @escaping(Result<ProductDetails, APIError>) -> Void)
}

final class ProductDetailsService: ProductDetailsServicing {
    func fetchProductDetails(productId: String, completion: @escaping(Result<ProductDetails, APIError>) -> Void) {
        guard let urlHost = Api.apiUrl else {
            completion(.failure(.genericError))
            return
        }
        let endpoint = ProductDetailsEndpoint.fetchProductDetails(productId: productId)
        
        guard let url = URL(string: urlHost + endpoint.path) else {
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.params).responseJSON { (result) in
            guard let data = result.data else {
                completion(.failure(.genericError))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode([ProductDetailsResponse].self, from: data)
                
                guard let body = response.first?.body else {
                    completion(.failure(.genericError))
                    return
                }
                completion(.success(body))
                
            } catch { completion(.failure(.genericError)) }
        }
    }
}
