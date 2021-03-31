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
            guard error == nil, let image = image else { return }
            let newSize = self.resize(image: image)
            let newImage = self.resizeImage(image: image, targetSize: newSize)
            self.pictureImageView.image = newImage
            self.pictureImageView.snp.makeConstraints {
                $0.size.equalTo(newSize)
                $0.centerY.centerX.equalToSuperview()
            }
        }
    }
    
    func resize(image: UIImage) -> CGSize {
        let ratio = image.size.width / image.size.height
        if frame.width < frame.height {
            let newHeight = frame.width / ratio
            return CGSize(width: frame.width, height: newHeight)
        } else {
            let newWidth = frame.height * ratio
            return CGSize(width: newWidth, height: frame.height)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

// MARK: - ViewConfiguration
extension PictureCollectionCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(pictureImageView)
    }
    
    func setupConstraints() { }
    
    func configureViews() {
        backgroundColor = UIColor(named: Strings.Color.primaryBackground)
    }
}
