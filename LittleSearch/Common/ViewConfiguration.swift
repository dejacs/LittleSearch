//
//  ViewConfiguration.swift
//  LittleSearch
//
//  Created by Jade Silveira on 27/03/21.
//

import Foundation

protocol ViewConfiguration {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}
