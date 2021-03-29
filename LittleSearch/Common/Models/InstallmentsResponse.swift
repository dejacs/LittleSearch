//
//  InstallmentsResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 27/03/21.
//

import Foundation

struct InstallmentsResponse: Decodable, Equatable {
    let quantity: Int
    let amount: Double
    let rate: Double
}
