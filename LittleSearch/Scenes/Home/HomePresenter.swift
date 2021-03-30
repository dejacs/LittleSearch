//
//  HomePresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func present(searchDataSource: [SearchItemResponse])
    func present(totalResults: Int)
    func didSelect(searchItem: SearchItemResponse)
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
    func present(searchDataSource: [SearchItemResponse]) {
        viewController?.display(searchDataSource: searchDataSource)
    }
    
    func present(totalResults: Int) {
        viewController?.display(totalResults: totalResults)
    }
    
    func didSelect(searchItem: SearchItemResponse) {
        coordinator.perform(action: .showProductDetails(searchItem))
    }
    
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
    
    func presentEmpty() {
        
    }
    
    func presentError() {
        
    }
}
