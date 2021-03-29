//
//  FormatUtils.swift
//  LittleSearch
//
//  Created by Jade Silveira on 29/03/21.
//

import Foundation

class FormatUtils {
    static func format(quantity: Int, keyTextSingle: String, keyTextMultiple: String) -> String {
        let localizableKey = quantity == 1 ? keyTextSingle : keyTextMultiple
        let quantityText = NSLocalizedString(localizableKey, comment: "")
        return String(format: quantityText, quantity.description)
    }
}
