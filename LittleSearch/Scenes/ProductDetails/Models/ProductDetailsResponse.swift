//
//  ProductDetailsResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

struct ProductDetailsResponse: Decodable {
    let code: Int
    let body: ProductDetails
}
