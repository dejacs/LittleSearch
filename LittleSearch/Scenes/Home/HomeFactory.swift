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
        let service: HomeServicing = HomeService()
        let interactor = HomeInteractor(presenter: presenter, service: service)
        let viewController = HomeViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController

        return viewController
    }
}
