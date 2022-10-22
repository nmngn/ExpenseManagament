//
//  TransactionTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    func setupData(model: HomeModel) {
        imageCategory.image = UIImage(named: model.category)
        titleLabel.text = model.titleExpense
        timeLabel.text = model.timeExpense
        moneyLabel.text = "- \(model.moneyExpense)"
    }
    
}
