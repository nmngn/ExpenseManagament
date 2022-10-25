//
//  TransactionTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

protocol DataTransaction {
    func getTitle() -> String
    func getTime() -> String
    func getCategory() -> String
    func getAmount() -> Int
}

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    func setupData(model: DataTransaction) {
        imageCategory.image = UIImage(named: model.getCategory())
        titleLabel.text = model.getTitle()
        timeLabel.text = model.getTime()
        moneyLabel.text = "- \(model.getAmount().formattedWithSeparator)"
    }
}
