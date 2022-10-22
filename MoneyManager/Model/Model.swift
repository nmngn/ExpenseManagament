//
//  RealmModel.swift
//  MoneyManager
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import ObjectMapper
import Alamofire

struct User: Mappable {
    var name = ""
    var birth = ""
    var money = 0
    var idUser = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idUser <- map["id"]
        name <- map["name"]
        birth <- map["dayOfBirth"]
        money <- map["money"]
    }
}

struct SuperTransaction: Mappable {
    var transactions: [Transaction]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        transactions <- map["data"]
    }
}

struct Transaction : Mappable {
    var id = ""
    var idUser = ""
    var title = ""
    var description = ""
    var amount = 0
    var category = ""
    var dateTime = ""
    var isIncome = false
    var type = false
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        idUser <- map["idUser"]
        title <- map["title"]
        description <- map["description"]
        amount <- map["amount"]
        category <- map["category"]
        dateTime <- map["dateTime"]
        isIncome <- map["isIncome"]
    }
}
