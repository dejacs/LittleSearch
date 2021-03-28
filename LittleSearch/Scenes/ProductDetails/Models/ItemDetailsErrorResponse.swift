//
//  ItemDetailsErrorResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 27/03/21.
//

import Foundation

struct ItemDetailsErrorResponse: Decodable, Equatable, ItemDetailsBodyResponse {
    let message: String
    let error: String
    let status: Int
}
