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

extension ProductDetailsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(loadingView)
        view.addSubview(soldQuantityLabel)
        view.addSubview(titleLabel)
        view.addSubview(photoCollection)
        view.addSubview(priceLabel)
        view.addSubview(installmentsLabel)
        view.addSubview(availableQuantityLabel)
    }
    
    func setupConstraints() {
        loadingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        soldQuantityLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(LayoutDefaults.View.margin01)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(soldQuantityLabel.snp.bottom).offset(LayoutDefaults.View.margin00)
            $0.leading.equalToSuperview().offset(LayoutDefaults.View.margin01)
            $0.trailing.lessThanOrEqualToSuperview().offset(-LayoutDefaults.View.margin01)
        }
        
        photoCollection.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
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
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        view.backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 300)
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        interactor.didSelect(picture: pictures?[indexPath.row])
        // TODO: slide show
    }
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        pictures?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let picture = pictures?[indexPath.section] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionCell.identifier, for: indexPath) as! PictureCollectionCell
        cell.setup(with: picture)
        return cell
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
}
