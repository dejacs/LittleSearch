//
//  ProductDetailsService.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ProductDetailsServicing {
    func fetchProductDetails(productId: String)
}

final class ProductDetailsService: ProductDetailsServicing {
    func fetchProductDetails(productId: String) {
        guard let url = URL(string: "https://api.mercadolibre.com/items?ids=\(productId)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, let dataParse = String(data: data, encoding: .utf8) else { return }
            print(dataParse)
        }
        
        task.resume()
    }
}
