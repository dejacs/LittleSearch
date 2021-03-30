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
    private var searchDataSource: [SearchItemResponse] = []

    init(presenter: HomePresenting) {
        self.presenter = presenter
    }
}

extension HomeInteractor: HomeInteracting {
    func search(by text: String?) {
        searchText = text ?? searchText
        guard let text = searchText.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            return
        }
        presenter.presentLoading(shouldPresent: true)
        let endpoint = HomeEndpoint.fetchSearchItems(text: text, itemsPerPage: itemsPerPage, page: page)
        
        ApiSearch.fetch(endpoint: endpoint) { [weak self] (result: Result<SearchResponse, APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let searchResponse) where searchResponse.results.isEmpty:
                self?.presenter.presentEmpty()
            case .success(let searchResponse):
                guard let strongSelf = self else {
                    self?.presenter.presentError()
                    return
                }
                strongSelf.page += 1
                strongSelf.searchDataSource.append(contentsOf: searchResponse.results)
                strongSelf.presenter.present(totalResults: searchResponse.totalResults)
                strongSelf.presenter.present(searchDataSource: strongSelf.searchDataSource)
            case .failure:
                self?.presenter.presentError()
            }
        }
    }
    
    func didSelect(searchItem: SearchItemResponse) {
        presenter.didSelect(searchItem: searchItem)
    }
}
