//
//  ItemTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/10/2022.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    func setupData(data: ExpenseModel) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        moneyLabel.text = "\(data.amount.formattedWithSeparator)"
        descriptionLabel.text = data.description
        imageCategory.image = UIImage(named: data.category)
    }
    
}
