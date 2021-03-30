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
    func didSelect(searchItem: SearchItemResponse)
    func presentLoading(shouldPresent: Bool)
    func presentEmpty()
    func presentError()
    func presentErrorCell()
    func presentLoadingCell(shouldPresent: Bool)
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
        viewController?.display(searchResponse: searchResponse)
    }
    
    func didSelect(searchItem: SearchItemResponse) {
        coordinator.perform(action: .showProductDetails(searchItem))
    }
    
    func presentLoading(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
    
    func presentEmpty() {
        viewController?.displayEmpty()
    }
    
    func presentError() {
        viewController?.displayError()
    }
    
    func presentErrorCell() {
        viewController?.displayErrorCell()
    }
    
    func presentLoadingCell(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoadingCell() : viewController?.stopLoadingCell()
    }
}
