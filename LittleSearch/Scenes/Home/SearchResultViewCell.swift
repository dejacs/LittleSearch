//
//  SearchResultViewCell.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation
import SnapKit
import UIKit

class SearchResultViewCell: UITableViewCell {
    static let identifier = "SearchResultViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img_placeholder"))
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    func setup(_ searchItem: SearchItem) {
        titleLabel.text = searchItem.title
        priceLabel.text = searchItem.price.description // TODO: converter e formatar
    }
}

extension SearchResultViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
    }
    
    func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 60))
            $0.top.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        priceLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configureViews() {
        backgroundColor = .clear
    }
}
