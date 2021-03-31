//
//  HomeCoordinator.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation
import UIKit

enum HomeCoordinatorAction: Equatable {
    case showProductDetails(_ searchItem: SearchItemResponse)
}

protocol HomeCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: HomeCoordinatorAction)
}

final class HomeCoordinator {
    weak var viewController: UIViewController?
}

// MARK: - HomeCoordinating
extension HomeCoordinator: HomeCoordinating {
    func perform(action: HomeCoordinatorAction) {
        if case .showProductDetails(let searchItem) = action {
            viewController?.navigationController?.pushViewController(ProductDetailsFactory.make(with: searchItem), animated: true)
        }
    }
}
