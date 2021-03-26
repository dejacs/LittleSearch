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
        service.fetchSearchItems(by: text) { completion in
            switch completion {
            case .success(let searchItems):
                break
            case .failure:
                break
            }
        }
    }
    
    func didSelect(productId: String) {
        presenter.didSelect(productId: productId)
    }
}
