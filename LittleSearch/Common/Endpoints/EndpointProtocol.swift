//
//  EndpointProtocol.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Alamofire
import Foundation

protocol EndpointProtocol {
    var path: String { get  }
    var method: HTTPMethod { get }
    var params: Parameters { get }
}
