//
//  HomeFactory.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import UIKit

enum HomeFactory {
    static func make() -> HomeViewController {
        let coordinator: HomeCoordinating = HomeCoordinator()
        let presenter: HomePresenting = HomePresenter(coordinator: coordinator)
        let interactor = HomeInteractor(presenter: presenter)
        let viewController = HomeViewController(interactor: interactor)
        
        presenter.viewController = viewController

        return viewController
    }
}
