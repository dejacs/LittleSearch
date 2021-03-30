//
//  ViewHelpers.swift
//  LittleSearch
//
//  Created by Jade Silveira on 30/03/21.
//

import Foundation
import UIKit

class ViewHelpers {
    static func toastLabel(message : String, font: UIFont) -> UILabel {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 0
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        return toastLabel
    }
    
    static func addFadeAnimation(to view: UIView) {
        view.alpha = 1.0
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }
}
