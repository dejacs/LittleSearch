//
//  ProductDetailsViewController.swift
//  LittleSearch
//
//  Created by Jade Silveira on 25/03/21.
//

import Foundation
import UIKit

protocol ProductDetailsDisplaying: AnyObject {
    func startLoading()
    func stopLoading()
    func setTitle(with title: String)
    func setAvailableQuantity(with quantity: Int)
    func setSoldQuantity(with quantity: Int)
    func setPictures(with pictures: [ProductPicture])
    func setAttributes(with attributes: [ProductAttribute])
}

final class ProductDetailsViewController: UIViewController {
    private enum Layout {
        enum StackView {
            static let layoutSpacing: CGFloat = 16
            static let layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        }
        return UIActivityIndicatorView(style: .medium)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.StackView.layoutSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Layout.StackView.layoutMargins
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var availableQuantityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var soldQuantityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let interactor: ProductDetailsInteracting
    
    init(interactor: ProductDetailsInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        
        interactor.loadProductDetails()
    }
}

private extension ProductDetailsViewController {
    func buildViewHierarchy() {
        view.addSubview(loadingView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(availableQuantityLabel)
        stackView.addArrangedSubview(soldQuantityLabel)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        stackView.backgroundColor = .clear
    }
}

extension ProductDetailsViewController: ProductDetailsDisplaying {
    func startLoading() {
        view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func setTitle(with title: String) {
        titleLabel.text = title
    }
    
    func setAvailableQuantity(with quantity: Int) {
        availableQuantityLabel.text = quantity.description
    }
    
    func setSoldQuantity(with quantity: Int) {
        soldQuantityLabel.text = quantity.description
    }
    
    func setPictures(with pictures: [ProductPicture]) {
        // TODO: implementar carousel
    }
    
    func setAttributes(with attributes: [ProductAttribute]) {
        // TODO: implementar collection
    }
}
