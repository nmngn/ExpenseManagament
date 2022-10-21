//
//  BadgeTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 21/10/2022.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var remainMoney = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.progress = 0
    }
    
    func setupData(data: HomeModel) {
        allLabel.text = "\(data.allMoney)"
        usedLabel.text = "\(data.usedMoney)"
        remainLabel.text = "\(data.remainMoney)"
        
        if data.remainMoney == 0 {
            remainMoney = 1
        } else {
            remainMoney = data.remainMoney
        }
        
        let ratio = Float(remainMoney) / Float(data.allMoney )
        if ratio > 0.6 {
            progressView.progressTintColor = UIColor(hex: "#046809")
        } else if ratio < 0.3 {
            progressView.progressTintColor = .systemRed
        } else {
            progressView.progressTintColor = .yellow
        }
        
        progressView.setProgress(ratio, animated: true)
    }

    
}
