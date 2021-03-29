//
//  SearchResultViewHeader.swift
//  LittleSearch
//
//  Created by Jade Silveira on 27/03/21.
//

import Foundation
import SnapKit
import UIKit

final class SearchResultViewHeader: UIView {
    private lazy var totalResultsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = UIColor(named: "clr_secondary_text")
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    func display(totalResults: Int) {
        totalResultsLabel.text = totalResults.description + " resultados"
    }
}

extension SearchResultViewHeader: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(totalResultsLabel)
    }
    
    func setupConstraints() {
        totalResultsLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: "clr_primary_background")
    }
}
