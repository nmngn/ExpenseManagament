//
//  WelcomeTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var delegate: HomeActionDelegete?
    
    func setupData(model: HomeModel) {
        let userName = model.userName
        titleLabel.text = "Xin chào, \(userName)"
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        delegate?.openProfile()
    }
    
}
