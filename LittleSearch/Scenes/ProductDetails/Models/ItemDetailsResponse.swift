//
//  ItemDetailsResponse.swift
//  LittleSearch
//
//  Created by Jade Silveira on 26/03/21.
//

import Foundation

protocol ItemDetailsBodyResponse { }

struct ItemDetailsResponse: Decodable, Equatable {
    let code: Int
    let body: ItemDetailsBodyResponse
    
    private enum CodingKeys: String, CodingKey {
        case code, body
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        
        guard code == 200 else {
            body = try container.decode(ItemDetailsErrorResponse.self, forKey: .body)
            return
        }
        body = try container.decode(ItemDetailsSuccessResponse.self, forKey: .body)
    }
    
    static func == (lhs: ItemDetailsResponse, rhs: ItemDetailsResponse) -> Bool {
        guard lhs.code == 200, rhs.code == 200 else {
            guard
                let lhsError = lhs.body as? ItemDetailsErrorResponse,
                let rhsError = rhs.body as? ItemDetailsErrorResponse
            else {
                return false
            }
            return lhsError == rhsError
        }
        guard
            let lhsSuccess = lhs.body as? ItemDetailsSuccessResponse,
            let rhsSuccess = rhs.body as? ItemDetailsSuccessResponse
        else {
            return false
        }
        return lhsSuccess == rhsSuccess
    }
}
