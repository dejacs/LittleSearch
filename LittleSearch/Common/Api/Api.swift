//
//  Api.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

enum APIError: Error {
    case genericError
    case notFound
}

class Api {
    static var apiUrl: String? {
        return get("API_HOST")
    }
    
    static var siteId: String? {
        return get("SITE_ID")
    }
    
    static func get<T>(_ name: String, bundle: Bundle = Bundle.main) -> T? {
        guard let enviromentSetting = bundle.infoDictionary?["EnviromentSetting"] as? [String: AnyObject],
            let key = enviromentSetting[name] else {
            return nil
        }
        
        return key as? T
    }
}
