//
//  Repository.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation

struct Repositories {
    let api: ApiService
    
    func createUser(name: String, birth: String, allMoney: Int, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(name: name, birth: birth, allMoney: allMoney)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getOneUser(idUser: String, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func updateUser(idUser: String, name: String, birth: String, allMoney: Int, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser, name: name, birth: birth, allMoney: allMoney)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func createTransaction(idUser: String, title: String, description: String, amount: String, category: String, dateTime: String, isIncome: Bool, type: Bool, completion: @escaping (BaseResult<Transaction>) -> Void) {
    let input = TransactionRequest(idUser: idUser, title: title, description: description, amount: amount, category: category, dateTime: dateTime, isIncome: isIncome, type: type)
        api.request(input: input) { (object : Transaction?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func updateTransaction(transactionId: String, title: String, description: String, amount: String, category: String, isIncome: Bool, completion: @escaping (BaseResult<Transaction>) -> Void) {
        let input = TransactionRequest(transactionId: transactionId, title: title, description: description, amount: amount, category: category, isIncome: isIncome)
        api.request(input: input) { (object : Transaction?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func deleteTransaction(transactionId: String, completion: @escaping (BaseResult<Transaction>) -> Void) {
        let input = TransactionRequest(transactionId: transactionId)
        api.request(input: input) { (object : Transaction?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getAllTransaction(idUser: String, completion: @escaping (BaseResult<SuperTransaction>) -> Void) {
        let input = TransactionRequest(idUser: idUser)
        api.request(input: input) { (object: SuperTransaction? , error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getOneTransaction(transactionId: String, completion: @escaping (BaseResult<Transaction>) -> Void) {
        let input = TransactionRequest(transactionId: transactionId, type: .get)
        api.request(input: input) { (object : Transaction?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getTransactionRangeData(sDay: String, eDay: String, completion: @escaping (BaseResult<Transaction>) -> Void) {
        let input = TransactionRequest(sDay: sDay, eDay: eDay)
        api.request(input: input) { (object : Transaction?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
