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
    func setAvailableQuantity(with quantity: String)
    func setSoldQuantity(with quantity: String)
    func setPictures(with pictures: [ItemDetailsPictureResponse])
    func setAttributes(with attributes: [ItemDetailsAttributeResponse])
    func setPrice(_ price: Double)
    func setInstallments(_ installments: String?)
    func displayError()
    func hideError()
}

final class ProductDetailsViewController: UIViewController {
    private enum Layout {
        enum StackView {
            static let layoutSpacing: CGFloat = 16
            static let layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
        enum PhotoCollection {
            static let height: CGFloat = 300
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        }
        return UIActivityIndicatorView(style: .medium)
    }()
    
    private lazy var errorView: UIView = {
        let view = ErrorView()
        view.delegate = self
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var soldQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base00)
        label.textColor = UIColor(named: Strings.Color.tertiaryText)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base02)
        label.textColor = UIColor(named: Strings.Color.primaryText)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var photoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: Strings.Color.primaryBackground)
        collection.dataSource = self
        collection.delegate = self
        collection.register(PictureCollectionCell.self, forCellWithReuseIdentifier: PictureCollectionCell.identifier)
        return collection
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base0X)
        label.textColor = UIColor(named: Strings.Color.primaryText)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var installmentsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base00)
        label.textColor = UIColor(named: Strings.Color.highlight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var availableQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(LayoutDefaults.FontSize.base00)
        label.textColor = UIColor(named: Strings.Color.primaryText)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interactor: ProductDetailsInteracting
    private var pictures: [ItemDetailsPictureResponse]?
    private var attributes: [ItemDetailsAttributeResponse]?
    
    init(interactor: ProductDetailsInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadProductDetails()
    }
}

// MARK: - ViewConfiguration
extension ProductDetailsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(loadingView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(soldQuantityLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(photoCollection)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(installmentsLabel)
        scrollView.addSubview(availableQuantityLabel)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        soldQuantityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(soldQuantityLabel.snp.bottom).offset(LayoutDefaults.View.margin00)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        photoCollection.snp.makeConstraints {
            $0.height.equalTo(Layout.PhotoCollection.height)
            $0.width.equalTo(UIScreen.main.bounds.width - LayoutDefaults.View.margin02)
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.equalToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(photoCollection.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        installmentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        availableQuantityLabel.snp.makeConstraints {
            $0.top.equalTo(installmentsLabel.snp.bottom).offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
            $0.bottom.equalToSuperview().offset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        view.backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - LayoutDefaults.View.margin02, height: Layout.PhotoCollection.height)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        pictures?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let picture = pictures?[indexPath.section],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionCell.identifier, for: indexPath) as? PictureCollectionCell
        else {
            return UICollectionViewCell()
        }
        cell.setup(with: picture)
        return cell
    }
}

// MARK: - ProductDetailsDisplaying
extension ProductDetailsViewController: ProductDetailsDisplaying {
    func startLoading() {
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    func setTitle(with title: String) {
        titleLabel.text = title
    }
    
    func setAvailableQuantity(with quantity: String) {
        availableQuantityLabel.text = quantity
    }
    
    func setSoldQuantity(with quantity: String) {
        soldQuantityLabel.text = quantity
    }
    
    func setPrice(_ price: Double) {
        priceLabel.text = price.formatCurrency()
    }
    
    func setInstallments(_ installments: String?) {
        installmentsLabel.text = installments
    }
    
    func setPictures(with pictures: [ItemDetailsPictureResponse]) {
        self.pictures = pictures
        photoCollection.reloadData()
    }
    
    func setAttributes(with attributes: [ItemDetailsAttributeResponse]) {
        self.attributes = attributes
    }
    
    func displayError() {
        view.addSubview(errorView)
        view.bringSubviewToFront(errorView)
        errorView.isHidden = false
        
        errorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func hideError() {
        guard errorView.superview != nil else { return }
        errorView.isHidden = true
        errorView.removeFromSuperview()
    }
}

// MARK: - ErrorViewDelegate
extension ProductDetailsViewController: ErrorViewDelegate {
    func didTapButton() {
        interactor.loadProductDetails()
    }
}
