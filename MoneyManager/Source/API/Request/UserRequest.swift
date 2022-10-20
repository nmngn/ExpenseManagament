//
//  UserRequest.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class UserRequest: BaseRequest {
    required init(name: String, birth: String, allMoney: Int) { //create
        let url = URLs.createUser
        let body: [String: Any] = [
            "name": name,
            "dayOfBirth": birth,
            "addMoney": allMoney]
        super.init(url: url, requestType: .post, body: body)
    }
}
