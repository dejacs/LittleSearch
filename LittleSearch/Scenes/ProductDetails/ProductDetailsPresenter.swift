//
//  ProductDetailsPresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ProductDetailsPresenting: AnyObject {
    var viewController: ProductDetailsDisplaying? { get set }
}

final class ProductDetailsPresenter {
    weak var viewController: ProductDetailsDisplaying?
}

extension ProductDetailsPresenter: ProductDetailsPresenting {
    
}
