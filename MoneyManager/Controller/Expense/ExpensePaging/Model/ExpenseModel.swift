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
        
    var id = ""
    var title = ""
    var date = ""
    var amount = 0
    var description = ""
    var category = ""
    
    init(type: ExpenseScreenType) {
        self.type = type
    }
}
