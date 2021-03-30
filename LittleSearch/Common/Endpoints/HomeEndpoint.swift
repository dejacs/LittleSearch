//
//  HomeEndpoint.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

enum HomeEndpoint: EndpointProtocol {
    case fetchSearchItems(text: String, itemsPerPage: Int, page: Int)
    
    var path: String {
        switch self {
        case .fetchSearchItems:
            guard let api = Api.apiUrl, let site = Api.siteId else { return "" }
            return "\(api)/sites/\(site)/search"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var params: Parameters {
        switch self {
        case let .fetchSearchItems(text, itemsPerPage, page):
            return [ "q" : text , "limit" : itemsPerPage, "offset" : page ]
        }
    }
}
