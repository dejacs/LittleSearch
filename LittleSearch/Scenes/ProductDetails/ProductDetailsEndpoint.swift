//
//  ProductDetailsEndpoint.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

enum ProductDetailsEndpoint {
    case fetchProductDetails(productId: String)
    
    var path: String {
        switch self {
        case .fetchProductDetails:
            return "/items"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var params: Parameters {
        switch self {
        case .fetchProductDetails(let productId):
            return [ "ids" : productId ]
        }
    }
}
