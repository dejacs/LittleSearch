//
//  PictureCollectionCell.swift
//  LittleSearch
//
//  Created by Jade Silveira on 28/03/21.
//

import Foundation
import UIKit

final class PictureCollectionCell: UICollectionViewCell {
    private enum Layout {
        enum Cell {
            static let identifier = "PictureCollectionCell"
        }
    }
    static let identifier = Layout.Cell.identifier
    
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
        buildLayout()
        pictureImageView.sd_setImage(
            with: URL(string: picture.secureUrl),
            placeholderImage: UIImage(named: Strings.Placeholder.image)) { (image, error, _, _) in
            guard error == nil, let imageSize = image?.size else { return }
            self.pictureImageView.snp.makeConstraints {
                $0.size.equalTo(imageSize)
            }
        }
    }
}

extension PictureCollectionCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(pictureImageView)
    }
    
    func setupConstraints() {
        pictureImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 100))
            $0.centerX.centerY.equalToSuperview()
            $0.leading.top.greaterThanOrEqualToSuperview().inset(LayoutDefaults.View.margin01)
            $0.trailing.bottom.lessThanOrEqualToSuperview().inset(-LayoutDefaults.View.margin01)
        }
    }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}
