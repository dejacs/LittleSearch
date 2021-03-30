//
//  ErrorView.swift
//  LittleSearch
//
//  Created by Jade Silveira on 30/03/21.
//

import Foundation
import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTapButton()
}

final class ErrorView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img_error"))
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
        label.text = Strings.CommonMessage.errorSearchTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(LayoutDefaults.FontSize.base02)
        label.textColor = UIColor(named: Strings.Color.tertiaryText)
        label.text = Strings.CommonMessage.errorSearchMessage
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.CommonMessage.errorSearchButton, for: .normal)
        button.setTitleColor(UIColor(named: Strings.Color.linkText), for: .normal)
        button.addTarget(self, action: #selector(didTapTryAgainButton), for: .touchUpInside)
        return button
    }()
    
    var delegate: ErrorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

extension ErrorView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(tryAgainButton)
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
        tryAgainButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01)
            $0.bottom.trailing.lessThanOrEqualToSuperview().inset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}

@objc
extension ErrorView {
    func didTapTryAgainButton() {
        delegate?.didTapButton()
    }
}
