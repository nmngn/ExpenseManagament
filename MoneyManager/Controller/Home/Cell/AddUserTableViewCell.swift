//
//  AddUserTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 28/12/2021.
//

import UIKit

class AddUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    func setupData() {
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = UIColor(red: 0.45, green: 0.66, blue: 0.85, alpha: 1.00)
        } else {
            subView.backgroundColor = UIColor(red: 0.36, green: 0.30, blue: 0.59, alpha: 1.00)
        }
    }
    
}
