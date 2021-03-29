//
//  PictureCollectionCell.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Foundation
import UIKit

final class PictureCollectionCell: UICollectionViewCell {
    static let identifier = "PictureCollectionCell"
    
    private var isHeightCalculated: Bool = false
    
    private lazy var pictureImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentCompressionResistancePriority(for: .vertical)
        return view
    }()
    
    override func prepareForReuse() {
        pictureImageView.image = nil
    }
    
    func setup(with picture: ItemDetailsPictureResponse) {
        pictureImageView.sd_setImage(
            with: URL(string: picture.secureUrl),
            placeholderImage: UIImage(named: "img_placeholder")) { (image, error, _, _) in
            guard error == nil, let imageSize = image?.size else { return }
            self.pictureImageView.snp.makeConstraints {
                $0.size.equalTo(imageSize)
            }
        }
        buildLayout()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard !isHeightCalculated else { return layoutAttributes }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        layoutAttributes.frame = newFrame
        isHeightCalculated = true
        
        return layoutAttributes
    }
}

extension PictureCollectionCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(pictureImageView)
    }
    
    func setupConstraints() {
        pictureImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
