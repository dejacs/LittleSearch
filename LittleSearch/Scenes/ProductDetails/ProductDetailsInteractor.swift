//
//  ProductDetailsInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ProductDetailsInteracting: AnyObject {
    /**
     * Load product details
     *
     * It will manager what should be done when loading a product:
     *   - Loading
     *   - Error
     *   - Show loaded product
     *
     */
    func loadProductDetails()
}

final class ProductDetailsInteractor {
    private let presenter: ProductDetailsPresenting
    private let api: Api<ItemDetailsResponse>
    private let searchItem: SearchItemResponse

    init(presenter: ProductDetailsPresenting, searchItem: SearchItemResponse, api: Api<ItemDetailsResponse>) {
        self.presenter = presenter
        self.searchItem = searchItem
        self.api = api
    }
}

// MARK: - ProductDetailsInteracting
extension ProductDetailsInteractor: ProductDetailsInteracting {
    func loadProductDetails() {
        presenter.presentLoading(shouldPresent: true)
        let endpoint = ProductDetailsEndpoint.fetchProductDetails(productId: searchItem.id)
        
        api.fetchArray(endpoint: endpoint) { [weak self] (result: Result<[ItemDetailsResponse], APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let itemDetailsResponse):
                guard
                    let strongSelf = self,
                    let firstResponse = itemDetailsResponse.first,
                    firstResponse.code == StatusCode.success,
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
