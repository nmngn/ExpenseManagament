//
//  OptionTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    var delegate: HomeActionDelegete?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func openDefaultExpense(_ sender: UIButton) {
        delegate?.openDefaultExpense()
    }
    
    @IBAction func openFlexibleExpense(_ sender: UIButton) {
        delegate?.openFlexibleExpense()
    }
}
