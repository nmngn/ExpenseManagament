//
//  WelcomeTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let userName = Session.shared.userProfile.userName
        titleLabel.text = "Xin chào, \(userName)"
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        
    }
    
}
