//
//  ProductDetailsFactory.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

enum ProductDetailsFactory {
    static func make(with product: Int) -> ProductDetailsViewController {
        return ProductDetailsViewController()
    }
}
