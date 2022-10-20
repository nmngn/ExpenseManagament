//
//  TransactionRequest.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class TransactionRequest: BaseRequest {
    required init(idUser: String, title: String, description: String, amount: String, category: String, dateTime: String, isIncome: Bool, type: Bool) { //create
        let url = URLs.createTransaction
        let body: [String: Any] = [
            "idUser": idUser,
            "title": title,
            "description": description,
            "amount": amount,
            "isIncome": isIncome,
            "category": category,
            "dateTime": dateTime,
            "type": type
        ]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(transactionId: String, title: String, description: String, amount: String, category: String, isIncome: Bool) { //update
        let url = URLs.updateTransaction + transactionId
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "amount": amount,
            "isIncome": isIncome,
            "category": category,
        ]
        super.init(url: url, requestType: .put, body: body)
    }
    
    required init(transactionId: String) { //delete
        let url = URLs.deleteTransaction + transactionId
        super.init(url: url, requestType: .delete)
    }
    
    required init(transactionId: String, type: Alamofire.HTTPMethod) { //getOne
        let url = URLs.getOneTransaction + transactionId
        super.init(url: url, requestType: type)
    }
    
    required init(idUser: String) { //getAll
        let url = URLs.getAllTransaction
        super.init(url: url, requestType: .get)
    }
    
    required init(sDay: String, eDay: String) { // get data range date
        let url = URLs.getTransactionRangeDate
        let query = [
        URLQueryItem(name: sDay, value: sDay + " 00:00:00:000"),
        URLQueryItem(name: eDay, value: eDay + " 23:59:59:000")]
        super.init(url: url, requestType: .get, query: query)
    }
}
