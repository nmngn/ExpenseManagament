//
//  HomeTitleTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class HomeTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    func setupData(model: HomeModel) {
        titleLabel.text = model.title
    }
    
    func setupData(model: HistoryModel) {
        titleLabel.text = model.title
    }
    
}
