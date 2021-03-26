//
//  HomeEndpoint.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Alamofire
import Foundation

enum HomeEndpoint {
    case fetchSearchItems(site: String, text: String)
    
    var path: String {
        switch self {
        case .fetchSearchItems(let site, _):
            return "/sites/\(site)/search"
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
        case .fetchSearchItems(_, let text):
            return [ "q" : text ]
        }
    }
}
