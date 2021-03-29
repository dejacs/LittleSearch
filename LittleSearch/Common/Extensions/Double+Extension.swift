//
//  Double+Extension.swift
//  LittleSearch
//
//  Created by Jade Silveira on 29/03/21.
//

import Foundation

extension Double {
    func formatCurrency() -> String? {
        let number = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: Strings.Locale.brazil)
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number)
    }
}
