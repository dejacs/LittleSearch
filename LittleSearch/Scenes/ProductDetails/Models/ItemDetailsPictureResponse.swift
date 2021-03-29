//
//  ItemDetailsPictureResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

struct ItemDetailsPictureResponse: Decodable, Equatable {
    let secureUrl: String
    let size: String
    let maxSize: String
}
