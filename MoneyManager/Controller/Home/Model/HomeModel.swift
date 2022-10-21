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
    
    init(type: HomeType) {
        self.type = type
    }
}
