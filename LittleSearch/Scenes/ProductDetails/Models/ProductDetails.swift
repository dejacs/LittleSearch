//
//  ProductDetails.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

struct ProductDetails: Codable, Equatable {
    let id: String
    let title: String
    let availableQuantity: Int
    let soldQuantity: Int
    let secureThumbnail: String
    let pictures: [ProductPicture]
    let attributes: [ProductAttribute]
}
