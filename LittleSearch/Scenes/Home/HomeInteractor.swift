//
//  HomeInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomeInteracting: AnyObject {
    func search(by text: String?)
    func didSelect(searchItem: SearchItemResponse)
}

final class HomeInteractor {
    private let presenter: HomePresenting
    private let itemsPerPage = 10
    private var page = 0
    private var searchText = ""

    init(presenter: HomePresenting) {
        self.presenter = presenter
    }
}

extension HomeInteractor: HomeInteracting {
    func search(by text: String?) {
        presenter.presentLoading(shouldPresent: true)
        
        page = text != nil ? 0 : page
        searchText = text ?? searchText
        let endpoint = HomeEndpoint.fetchSearchItems(text: searchText, itemsPerPage: itemsPerPage, page: page)
        
        ApiSearch.fetch(endpoint: endpoint) { [weak self] (result: Result<SearchResponse, APIError>) in
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
    
    func didSelect(searchItem: SearchItemResponse) {
        presenter.didSelect(searchItem: searchItem)
    }
}
