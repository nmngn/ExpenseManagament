//
//  Session.swift
//  Spoon Master
//
//  Created by Nam Ngây on 10/01/2021.
//  Copyright © 2021 Nam Ngây. All rights reserved.
//

import Foundation
import UIKit

class Session {
    static var shared = Session()
    var userProfile = UserLogIn()
    var isPopToRoot = false
}

final class UserLogIn {
    var userName: String {
        get {
            UserDefaults.standard.string(forKey: "username") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
        }
    }
    var idUser: String {
        get {
            UserDefaults.standard.string(forKey: "idUser") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "idUser")
        }
    }
}

struct URLs {
    private static var baseUrl = "http://localhost:3001/"
    
    static var userUrl = baseUrl + "user/"
    
    static var createUser = userUrl
        
    static var transactionUrl = baseUrl + "transaction/"
        
    static var createTransaction = transactionUrl + "all/"
    static var getAllTransaction = transactionUrl
    static var getOneTransaction = transactionUrl
    static var updateTransaction = transactionUrl
    static var deleteTransaction = transactionUrl
    static var getTransactionRangeDate = transactionUrl
}
