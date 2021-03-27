//
//  HomePresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func present(searchItems: [SearchItem])
    func didSelect(productId: String)
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
    func present(searchItems: [SearchItem]) {
        viewController?.displaySearchResults(searchItems)
    }
    
    func didSelect(productId: String) {
        coordinator.perform(action: .showProductDetails(productId))
    }
    
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
}
