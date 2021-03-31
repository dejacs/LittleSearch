//
//  HomeInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomeInteracting: AnyObject {
    /**
     * Load items by text or reload items with the last provided text.
     *
     * It will manager what should be done when searching a product:
     *   - Loadings
     *   - Error
     *   - Empty
     *   - Show loaded items
     *
     *  - Parameter text: A text that will be used to search items with the title that contains it.
     *
     */
    func search(by text: String?)
    
    /**
     * Load items of the next page with the last provided text.
     *
     * It will manager what should be done when loading more items to the list:
     *   - Loadings
     *   - Error
     *   - Show loaded items
     *
     */
    func loadNextPage()
    
    /**
     * Load welcome page
     *
     * It will load the welcome page and hide other views
     *
     */
    func welcome()
    
    /**
     * Select item to be shown on next screen
     *
     *  - Parameter searchItem: The item to be shown on next screen.
     *
     */
    func didSelect(searchItem: SearchItemResponse)
}

final class HomeInteractor {
    private let presenter: HomePresenting
    private let api: ApiSearch<SearchResponse>
    private let itemsPerPage = 10
    private var page = 0
    private var searchText = ""

    init(presenter: HomePresenting, api: ApiSearch<SearchResponse>) {
        self.presenter = presenter
        self.api = api
    }
}

// MARK: - HomeInteracting
extension HomeInteractor: HomeInteracting {
    func search(by text: String?) {
        presenter.presentLoading(shouldPresent: true)
        
        page = text != nil ? 0 : page
        searchText = text ?? searchText
        let endpoint = HomeEndpoint.fetchSearchItems(text: searchText, itemsPerPage: itemsPerPage, page: page)
        
        api.fetch(endpoint: endpoint) { [weak self] (result: Result<SearchResponse, APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let searchResponse) where searchResponse.results.isEmpty:
                self?.presenter.presentEmpty()
            case .success(let searchResponse):
                self?.page += 1
                self?.presenter.present(searchResponse: searchResponse)
            case .failure:
                self?.presenter.presentError()
            }
        }
    }
    
    func loadNextPage() {
        presenter.presentLoadingCell(shouldPresent: true)
        
        let endpoint = HomeEndpoint.fetchSearchItems(text: searchText, itemsPerPage: itemsPerPage, page: page)
        
        api.fetch(endpoint: endpoint) { [weak self] (result: Result<SearchResponse, APIError>) in
            self?.presenter.presentLoadingCell(shouldPresent: false)
            
            switch result {
            case .success(let searchResponse):
                self?.page += 1
                self?.presenter.present(searchResponse: searchResponse)
            case .failure:
                self?.presenter.presentErrorCell()
            }
        }
    }
    
    func welcome() {
        presenter.presentWelcome()
    }
    
    func didSelect(searchItem: SearchItemResponse) {
        presenter.didSelect(searchItem: searchItem)
    }
}
