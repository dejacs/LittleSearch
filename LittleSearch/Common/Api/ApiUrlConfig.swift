//
//  ApiUrlConfig.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

final class ApiUrlConfig {
    static var host: String? {
        return get("API_HOST")
    }
    
    static var site: String? {
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
