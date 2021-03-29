//
//  SearchResultViewCell.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation
import SDWebImage
import SnapKit
import UIKit

final class SearchResultViewCell: UITableViewCell {
    private enum Layout {
        enum Cell {
            static let identifier = "SearchResultViewCell"
        }
    }
    
    static let identifier = Layout.Cell.identifier
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentCompressionResistancePriority(for: .vertical)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base01)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base03)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var installmentsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base00)
        label.textColor = UIColor(named: Strings.Color.highlight)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        installmentsLabel.text = nil
    }
    
    func setup(_ searchItem: SearchItemResponse) {
        thumbnailImageView.sd_setImage(
            with: URL(string: searchItem.thumbnail),
            placeholderImage: UIImage(named: Strings.Placeholder.image)) { (image, error, _, _) in
            guard error == nil, let imageSize = image?.size else { return }
            self.thumbnailImageView.snp.makeConstraints {
                $0.size.equalTo(imageSize)
            }
        }
        titleLabel.text = searchItem.title
        priceLabel.text = searchItem.price.formatCurrency()
        installmentsLabel.text = InstallmentsUtils.format(installments: searchItem.installments)
        layoutIfNeeded()
    }
}

extension SearchResultViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(installmentsLabel)
    }
    
    func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.leading.equalToSuperview().inset(LayoutDefaults.View.margin01)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01)
            $0.bottom.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(LayoutDefaults.View.margin01)
            $0.trailing.equalToSuperview().offset(-LayoutDefaults.View.margin01)
            
        }
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        installmentsLabel.snp.makeConstraints {
            $0.height.equalTo(13)
            $0.top.equalTo(priceLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
            $0.bottom.equalToSuperview().offset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.transparentBackground)
    }
}
