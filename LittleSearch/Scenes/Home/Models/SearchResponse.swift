//
//  SearchResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

struct SearchResponse: Decodable {
    let totalResults: Int
    let results: [SearchItemResponse]
    
    private enum CodingKeys: String, CodingKey {
        case paging, total, results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let paging = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .paging)
        totalResults = try paging.decode(Int.self, forKey: .total)
        results = try container.decode([SearchItemResponse].self, forKey: .results)
    }
}
