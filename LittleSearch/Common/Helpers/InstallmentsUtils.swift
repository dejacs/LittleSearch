//
//  InstallmentsUtils.swift
//  LittleSearch
//
//  Created by Jade Silveira on 29/03/21.
//

import Foundation

final class InstallmentsUtils {
    static func format(installments: InstallmentsResponse?) -> String {
        guard let installments = installments, let amount = installments.amount.formatCurrency() else {
            return ""
        }
        let quantity = installments.quantity.description + "x "
        let rate = installments.rate == 0 ? " sem juros" : ""
        return "em " + quantity + amount + rate
    }
}
