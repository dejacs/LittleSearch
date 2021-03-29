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
    
    private let searchItem: SearchItemResponse

    init(presenter: ProductDetailsPresenting, searchItem: SearchItemResponse) {
        self.presenter = presenter
        self.searchItem = searchItem
    }
}

extension ProductDetailsInteractor: ProductDetailsInteracting {
    func loadProductDetails() {
        presenter.presentLoading(shouldPresent: true)
        let endpoint = ProductDetailsEndpoint.fetchProductDetails(productId: searchItem.id)
        
        ApiSearch.fetchArray(endpoint: endpoint) { [weak self] (result: Result<[ItemDetailsResponse], APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let itemDetailsResponse):
                guard
                    let strongSelf = self,
                    let firstResponse = itemDetailsResponse.first,
                    firstResponse.code == 200,
                    let productDetails = firstResponse.body as? ItemDetailsSuccessResponse
                else {
                    self?.presenter.presentError()
                    return
                }
                strongSelf.presenter.present(productDetails: productDetails, installments: strongSelf.searchItem.installments)
            case .failure:
                self?.presenter.presentError()
            }
        }
    }
}
