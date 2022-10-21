//
//  HomeModel.swift
//  MoneyManager
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

enum HomeType {
    case welcome
    case badge
    case option
    case showRecent
    case transaction
    case banner
}

struct HomeModel {
    var type: HomeType
    
    var allMoney = 0
    var usedMoney = 0
    var remainMoney = 0
    
    var category = ""
    var titleExpense = ""
    var timeExpense = ""
    var moneyExpense = 0
    
    mutating func calc() {
        remainMoney = allMoney - usedMoney
    }
    
    init(type: HomeType) {
        self.type = type
    }
}
