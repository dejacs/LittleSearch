//
//  HomePresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func didSelect(product: Int)
    func presentLoading(shouldPresent: Bool)
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
    private let coordinator: HomeCoordinating

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

extension HomePresenter: HomePresenting {
    func didSelect(product: Int) {
        coordinator.perform(action: .showProductDetails(product))
    }
    
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
}
