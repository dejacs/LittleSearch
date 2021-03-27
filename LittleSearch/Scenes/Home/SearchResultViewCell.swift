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

class SearchResultViewCell: UITableViewCell {
    static let identifier = "SearchResultViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var installmentsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
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
        thumbnailImageView.sd_setImage(
            with: URL(string: searchItem.thumbnail),
            placeholderImage: UIImage(named: "img_placeholder")
        )
        titleLabel.text = searchItem.title
        priceLabel.text = format(currency: searchItem.price)
        installmentsLabel.text = format(installments: searchItem.installments)
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
            $0.size.equalTo(CGSize(width: 80, height: 60))
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(16)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            
        }
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        installmentsLabel.snp.makeConstraints {
            $0.height.equalTo(13)
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configureViews() {
        backgroundColor = .clear
    }
}

private extension SearchResultViewCell {
    func format(currency: Double) -> String? {
        let number = NSNumber(value: currency)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number)
    }
    
    func format(installments: Installments) -> String {
        guard let amount = format(currency: installments.amount) else {
            return ""
        }
        let quantity = installments.quantity.description + "x "
        let rate = installments.rate == 0 ? " sem juros" : ""
        return "em " + quantity + amount + rate
    }
}
