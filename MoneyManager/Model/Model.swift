//
//  RealmModel.swift
//  MoneyManager
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import ObjectMapper
import Alamofire

class User: Mappable {
    var name = ""
    var birth = ""
    var money = 0
    var idUser = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        idUser <- map["id"]
        name <- map["name"]
        birth <- map["dayOfBirth"]
        money <- map["allMoney"]
    }
}

class SuperTransaction: Mappable {
    var transactions: [Transaction]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        transactions <- map["data"]
    }
}

class Transaction : Mappable, DataTransaction {
    var id = ""
    var idUser = ""
    var title = ""
    var description = ""
    var amount = 0
    var category = ""
    var dateTime = ""
    var isIncome = false
    var type = false
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        idUser <- map["idUser"]
        title <- map["title"]
        description <- map["description"]
        amount <- map["amount"]
        category <- map["category"]
        dateTime <- map["dateTime"]
        isIncome <- map["isIncome"]
        type <- map["type"]
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getTime() -> String {
        return dateTime
    }
    
    func getCategory() -> String {
        return category
    }
    
    func getAmount() -> Int {
        return amount
    }
}

class MergedDataModel {
    var category : String
    var amount : Int
    
    init(category: String, amount: Int) {
        self.category = category
        self.amount = amount
    }
}
