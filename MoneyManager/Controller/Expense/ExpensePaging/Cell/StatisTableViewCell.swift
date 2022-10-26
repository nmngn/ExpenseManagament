//
//  StatisTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import UIKit

class StatisTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moneyLabel.adjustsFontSizeToFitWidth = true
        moneyLabel.minimumScaleFactor = 0.2
        moneyLabel.numberOfLines = 0
    }
    
    func setupData(usedMoney: Int, allMoney: Int) {
        if allMoney != 0 {
            let percent = Double(round(Double(usedMoney) / Double(allMoney) * 100))
            moneyLabel.text = "\(usedMoney.formattedWithSeparator) / \(allMoney.formattedWithSeparator) (\(percent)%)"
        }
    }
}
