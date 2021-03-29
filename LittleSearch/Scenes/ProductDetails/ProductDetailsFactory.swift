//
//  ProductDetailsFactory.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

enum ProductDetailsFactory {
    static func make(with searchItem: SearchItemResponse) -> ProductDetailsViewController {
        let presenter: ProductDetailsPresenting = ProductDetailsPresenter()
        let interactor = ProductDetailsInteractor(presenter: presenter, searchItem: searchItem)
        let viewController = ProductDetailsViewController(interactor: interactor)
        
        presenter.viewController = viewController

        return viewController
    }
}
