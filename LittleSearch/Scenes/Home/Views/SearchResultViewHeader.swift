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
        label.font = label.font.withSize(LayoutDefaults.FontSize.base01)
        label.textColor = UIColor(named: Strings.Color.secondaryText)
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
        let formattedResults = FormatUtils.format(
            quantity: totalResults,
            keyTextSingle: "totalResultsSingle",
            keyTextMultiple: "totalResultsMultiple"
        )
        totalResultsLabel.text = formattedResults
    }
}

// MARK: - ViewConfiguration
extension SearchResultViewHeader: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(totalResultsLabel)
    }
    
    func setupConstraints() {
        totalResultsLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}
