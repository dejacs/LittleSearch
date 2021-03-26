//
//  ProductDetailsFactory.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

enum ProductDetailsFactory {
    static func make(with productId: String) -> ProductDetailsViewController {
        let presenter: ProductDetailsPresenting = ProductDetailsPresenter()
        let service: ProductDetailsServicing = ProductDetailsService()
        let interactor = ProductDetailsInteractor(presenter: presenter, service: service, productId: productId)
        let viewController = ProductDetailsViewController(interactor: interactor)
        
        presenter.viewController = viewController

        return viewController
    }
}
