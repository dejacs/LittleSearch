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
    
    private let productId: String

    init(presenter: ProductDetailsPresenting, productId: String) {
        self.presenter = presenter
        self.productId = productId
    }
}

extension ProductDetailsInteractor: ProductDetailsInteracting {
    func loadProductDetails() {
        presenter.presentLoading(shouldPresent: true)
        let endpoint = ProductDetailsEndpoint.fetchProductDetails(productId: productId)
        
        ApiSearch.fetchArray(endpoint: endpoint) { [weak self] (result: Result<[ItemDetailsResponse], APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let itemDetailsResponse):
                guard
                    let firstResponse = itemDetailsResponse.first,
                    firstResponse.code == 200,
                    let productDetails = firstResponse.body as? ItemDetailsSuccessResponse
                else {
                    self?.presenter.presentError()
                    return
                }
                self?.presenter.present(productDetails: productDetails)
            case .failure:
                self?.presenter.presentError()
            }
        }
    }
}
