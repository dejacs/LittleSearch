//
//  SearchResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [SearchItem]
}

struct SearchItem: Decodable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
}
