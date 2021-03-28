//
//  HomeInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomeInteracting: AnyObject {
    func search(by text: String)
    func didSelect(productId: String)
}

final class HomeInteractor {
    private let presenter: HomePresenting

    init(presenter: HomePresenting) {
        self.presenter = presenter
    }
}

extension HomeInteractor: HomeInteracting {
    func search(by text: String) {
        guard let text = text.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else {
            return
        }
        presenter.presentLoading(shouldPresent: true)
        let endpoint = HomeEndpoint.fetchSearchItems(text: text)
        
        ApiSearch.fetch(endpoint: endpoint) { [weak self] (result: Result<SearchResponse, APIError>) in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch result {
            case .success(let searchResponse) where searchResponse.results.isEmpty:
                self?.presenter.presentEmpty()
            case .success(let searchResponse):
                self?.presenter.present(searchResponse: searchResponse)
            case .failure:
                self?.presenter.presentError()
            }
        }
    }
    
    func didSelect(productId: String) {
        presenter.didSelect(productId: productId)
    }
}
