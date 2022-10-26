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
    
    func setupData(data: [Transaction]) {
        
    }
}
