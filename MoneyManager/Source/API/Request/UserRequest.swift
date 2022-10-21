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
            "allMoney": allMoney]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(idUser: String) {
        let url = URLs.userUrl + idUser
        super.init(url: url, requestType: .get)
    }
    
    required init(idUser: String, name: String, birth: String, allMoney: Int) { //update
        let url = URLs.userUrl + idUser
        let body: [String: Any] = [
            "name": name,
            "dayOfBirth": birth,
            "allMoney": allMoney]
        super.init(url: url, requestType: .put, body: body)
    }
}
