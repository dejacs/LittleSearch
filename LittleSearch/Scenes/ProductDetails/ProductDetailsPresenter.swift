//
//  ProductDetailsPresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ProductDetailsPresenting: AnyObject {
    var viewController: ProductDetailsDisplaying? { get set }
    func presentLoading(shouldPresent: Bool)
    func present(productDetails: ProductDetails)
    func presentError()
}

final class ProductDetailsPresenter {
    weak var viewController: ProductDetailsDisplaying?
}

extension ProductDetailsPresenter: ProductDetailsPresenting {
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
    
    func present(productDetails: ProductDetails) {
        viewController?.setTitle(with: productDetails.title)
        viewController?.setAvailableQuantity(with: productDetails.availableQuantity)
        viewController?.setSoldQuantity(with: productDetails.soldQuantity)
        viewController?.setPictures(with: productDetails.pictures)
        viewController?.setAttributes(with: productDetails.attributes)
    }
    
    func presentError() {
        
    }
}
