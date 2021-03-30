//
//  WelcomeView.swift
//  LittleSearch
//
//  Created by Jade Silveira on 30/03/21.
//

import Foundation
import UIKit

final class WelcomeView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img_welcome"))
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentCompressionResistancePriority(for: .vertical)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(LayoutDefaults.FontSize.base0X)
        label.textColor = UIColor(named: Strings.Color.secondaryText)
        label.text = Strings.CommonMessage.welcomeTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(LayoutDefaults.FontSize.base02)
        label.textColor = UIColor(named: Strings.Color.secondaryText)
        label.text = Strings.CommonMessage.welcomeMessage
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var shakeTimer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    @objc func shakeImage() {
        imageView.shake()
    }
    
    func startTimer() {
        shakeTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(shakeImage), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        shakeTimer?.invalidate()
        shakeTimer = nil
    }
}

extension WelcomeView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutDefaults.View.margin01 * 2)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(LayoutDefaults.View.margin01 * 2)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01 * 2)
            $0.bottom.equalTo(imageView.snp.top).offset(-LayoutDefaults.View.margin01 * 2)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 150, height: 150))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snp.centerY).offset(-50)
            $0.bottom.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.branding)
    }
}
