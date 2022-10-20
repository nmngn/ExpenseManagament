//
//  BaseResult.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
