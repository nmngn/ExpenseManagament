//
//  StatisMonthlyTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import UIKit

class StatisMonthlyTableViewCell: UITableViewCell {

    @IBOutlet weak var allMoneyLabel: UILabel!
    @IBOutlet weak var stableUsedLabel: UILabel!
    @IBOutlet weak var stableMaxLabel: UILabel!
    @IBOutlet weak var flexibleUsedLabel: UILabel!
    @IBOutlet weak var flexibleMaxLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(data: [Transaction], user: User) {
        allMoneyLabel.text = "\(user.money.formattedWithSeparator)"

        var stableUsedMoney = 0
        var flexibleUsedMoney = 0
        var stableArray: [Transaction] = []
        var flexibleArray: [Transaction] = []
        
        for item in data {
            if item.type == true {
                stableUsedMoney += item.amount
                stableArray.append(item)
            } else {
                flexibleUsedMoney += item.amount
                flexibleArray.append(item)
            }
        }
        stableUsedLabel.text = "\(stableUsedMoney.formattedWithSeparator)"
        flexibleUsedLabel.text = "\(flexibleUsedMoney.formattedWithSeparator)"

        let newListStable = mergeList(list: stableArray).sorted(by: {$0.amount > $1.amount})
        if !newListStable.isEmpty {
            stableMaxLabel.text = "\(parseCategory(newListStable[0].category)) (\(newListStable[0].amount.formattedWithSeparator))"
        } else {
            stableMaxLabel.text = "Không có"
        }
        let newListFlexible = mergeList(list: flexibleArray).sorted(by: {$0.amount > $1.amount})
        if !newListFlexible.isEmpty {
            flexibleMaxLabel.text = "\(parseCategory(newListFlexible[0].category)) (\(newListFlexible[0].amount.formattedWithSeparator))"
        } else {
            flexibleMaxLabel.text = "Không có"
        }
        
        let remain = user.money - calculate(list: data)
        remainLabel.text = "\(remain.formattedWithSeparator)"
    }
}
