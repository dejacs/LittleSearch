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
    private let service: HomeServicing

    init(presenter: HomePresenting, service: HomeServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension HomeInteractor: HomeInteracting {
    func search(by text: String) {
        presenter.presentLoading(shouldPresent: true)
        
        service.fetchSearchItems(by: text) { [weak self] completion in
            self?.presenter.presentLoading(shouldPresent: false)
            
            switch completion {
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
