//
//  EmptyView.swift
//  LittleSearch
//
//  Created by Jade Silveira on 30/03/21.
//

import Foundation
import UIKit

final class EmptyView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img_empty"))
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentCompressionResistancePriority(for: .vertical)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(LayoutDefaults.FontSize.base03)
        label.textColor = UIColor(named: Strings.Color.secondaryText)
        label.text = Strings.CommonMessage.emptySearchTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(LayoutDefaults.FontSize.base02)
        label.textColor = UIColor(named: Strings.Color.tertiaryText)
        label.text = Strings.CommonMessage.emptySearchMessage
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

extension EmptyView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 100))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-LayoutDefaults.View.margin01 * 2)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01 * 2)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01 * 2)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}
