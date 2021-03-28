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
    func setPictures(with pictures: [ItemDetailsPictureResponse])
    func setAttributes(with attributes: [ItemDetailsAttributeResponse])
    func setPrice(_ price: Double)
    func setInstallments(_ installments: Installments)
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
    
    private lazy var soldQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var installmentsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var availableQuantityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        stackView.addArrangedSubview(soldQuantityLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(installmentsLabel)
        stackView.addArrangedSubview(availableQuantityLabel)
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
    
    func setPrice(_ price: Double) {
        priceLabel.text = format(currency: price)
    }
    
    func setInstallments(_ installments: Installments) {
        installmentsLabel.text = format(installments: installments)
    }
    
    func setPictures(with pictures: [ItemDetailsPictureResponse]) {
        // TODO: implementar carousel
    }
    
    func setAttributes(with attributes: [ItemDetailsAttributeResponse]) {
        // TODO: implementar collection
    }
}

private extension ProductDetailsViewController {
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
