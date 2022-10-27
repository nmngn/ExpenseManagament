//
//  StatisModel.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import Foundation

enum StatisPagingType {
    case barChart
    case info
}

struct StatisPagingModel {
    var type: StatisPagingType
    
    var list = [Transaction]()
    var userData: User?
     
    init(type: StatisPagingType) {
        self.type = type
    }
}
