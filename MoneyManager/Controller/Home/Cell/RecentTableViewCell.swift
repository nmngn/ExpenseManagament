//
//  RecentTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var delegate: HomeActionDelegete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func showAll(_ sender: UIButton) {
        delegate?.showAllRecent()
    }
    
    @IBAction func reload(_ sender: UIButton) {
        
    }
}
