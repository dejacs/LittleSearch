//
//  HomePresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func present(searchResponse: SearchResponse)
    func didSelect(productId: String)
    func presentLoading(shouldPresent: Bool)
    func presentEmpty()
    func presentError()
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
    private let coordinator: HomeCoordinating

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

extension HomePresenter: HomePresenting {
    func present(searchResponse: SearchResponse) {
        viewController?.display(totalResults: searchResponse.paging.total)
        viewController?.display(searchResults: searchResponse.results)
    }
    
    func didSelect(productId: String) {
        coordinator.perform(action: .showProductDetails(productId))
    }
    
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
    
    func presentEmpty() {
        
    }
    
    func presentError() {
        
    }
}
