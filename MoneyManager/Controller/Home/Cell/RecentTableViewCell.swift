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
        titleLabel.text = "Nguồn chi cố định"
    }
    
    @IBAction func showAll(_ sender: UIButton) {
        delegate?.showAllRecent()
    }
    
    @IBAction func reload(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } completion: { isAnimationComplete in
            UIView.animate(withDuration: 1) {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            }
        }
        if delegate?.reloadExpense() ?? false {
            if titleLabel.text == "Nguồn chi cố định" {
                titleLabel.text = "Nguồn chi linh hoạt"
            } else {
                titleLabel.text = "Nguồn chi cố định"
            }
        }
    }
}
