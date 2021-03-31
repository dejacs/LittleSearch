//
//  ProductDetailsEndpoint.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

enum ProductDetailsEndpoint: EndpointProtocol {
    case fetchProductDetails(productId: String)
    
    var path: String {
        guard let host = ApiUrlConfig.host else { return "" }
        return "\(host)/items"
    }
    
    var method: HTTPMethod { .get }
    
    var params: Parameters {
        switch self {
        case .fetchProductDetails(let productId):
            return [ "ids" : productId ]
        }
    }
}
