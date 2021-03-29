//
//  SearchItemResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 27/03/21.
//

import Foundation

struct SearchItemResponse: Decodable, Equatable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    let installments: InstallmentsResponse?
}
