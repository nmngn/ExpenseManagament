//
//  ExpenseModel.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/10/2022.
//

import Foundation

enum ExpenseScreenType {
    case pieChart
    case item
    case add
}

struct ExpenseModel {
    var type: ExpenseScreenType
    
    init(type: ExpenseScreenType) {
        self.type = type
    }
}
