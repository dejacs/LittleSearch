//
//  HomePresenter.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
}

extension HomePresenter: HomePresenting {
    
}
