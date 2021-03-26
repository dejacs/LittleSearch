//
//  ProductDetailsInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ProductDetailsInteracting: AnyObject {
    func loadProductDetails()
}

final class ProductDetailsInteractor {
    private let presenter: ProductDetailsPresenting
    private let service: ProductDetailsServicing
    
    private let productId: String

    init(presenter: ProductDetailsPresenting, service: ProductDetailsServicing, productId: String) {
        self.presenter = presenter
        self.service = service
        self.productId = productId
    }
}

extension ProductDetailsInteractor: ProductDetailsInteracting {
    func loadProductDetails() {
        service.fetchProductDetails(productId: productId)
    }
}
