//
//  HomeService.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

protocol HomeServicing {
    func fetchSearchItems(by text: String, completion: @escaping(Result<[SearchItem], APIError>) -> Void)
}

final class HomeService: HomeServicing {
    func fetchSearchItems(by text: String, completion: @escaping(Result<[SearchItem], APIError>) -> Void) {
        guard
            let urlHost = Api.apiUrl,
            let urlSite = Api.siteId,
            let formattedText = text.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)
        else {
            completion(.failure(.genericError))
            return
        }
        let endpoint = HomeEndpoint.fetchSearchItems(site: urlSite, text: formattedText)
        
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
                let response = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(response.results))
                
            } catch { completion(.failure(.genericError)) }
        }
    }
}
