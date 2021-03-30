//
//  UIView+Extension.swift
//  LittleSearch
//
//  Created by Jade Silveira on 30/03/21.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let midX = center.x
        let midY = center.y

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        layer.add(animation, forKey: "position")
    }
}
