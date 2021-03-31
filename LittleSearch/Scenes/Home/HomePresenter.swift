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
    func presentWelcome()
    func presentLoadingCell(shouldPresent: Bool)
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
    private let coordinator: HomeCoordinating

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - HomePresenting
extension HomePresenter: HomePresenting {
    func present(searchResponse: SearchResponse) {
        viewController?.displayWelcome(shouldDisplay: false)
        viewController?.hideEmpty()
        viewController?.hideError()
        viewController?.display(searchResponse: searchResponse)
        viewController?.displaySearchResponse(shouldDisplay: true)
    }
    
    func didSelect(searchItem: SearchItemResponse) {
        coordinator.perform(action: .showProductDetails(searchItem))
    }
    
    func presentLoading(shouldPresent: Bool) {
        viewController?.displaySearchResponse(shouldDisplay: false)
        viewController?.displayWelcome(shouldDisplay: false)
        viewController?.hideEmpty()
        viewController?.hideError()
        shouldPresent ? viewController?.startLoading() : viewController?.stopLoading()
    }
    
    func presentEmpty() {
        viewController?.displaySearchResponse(shouldDisplay: false)
        viewController?.displayWelcome(shouldDisplay: false)
        viewController?.hideEmpty()
        viewController?.hideError()
        viewController?.displayEmpty()
    }
    
    func presentError() {
        viewController?.displaySearchResponse(shouldDisplay: false)
        viewController?.displayWelcome(shouldDisplay: false)
        viewController?.hideEmpty()
        viewController?.hideError()
        viewController?.displayError()
    }
    
    func presentErrorCell() {
        viewController?.displayErrorCell()
    }
    
    func presentWelcome() {
        viewController?.displaySearchResponse(shouldDisplay: false)
        viewController?.hideEmpty()
        viewController?.hideError()
        viewController?.displayWelcome(shouldDisplay: true)
    }
    
    func presentLoadingCell(shouldPresent: Bool) {
        shouldPresent ? viewController?.startLoadingCell() : viewController?.stopLoadingCell()
    }
}
