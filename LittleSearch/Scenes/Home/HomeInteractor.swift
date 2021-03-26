//
//  HomeInteractor.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomeInteracting: AnyObject {
    func didSelect(productId: String)
}

final class HomeInteractor {
    private let presenter: HomePresenting

    init(presenter: HomePresenting) {
        self.presenter = presenter
    }
}

extension HomeInteractor: HomeInteracting {
    func didSelect(productId: String) {
        presenter.didSelect(productId: productId)
    }
}
