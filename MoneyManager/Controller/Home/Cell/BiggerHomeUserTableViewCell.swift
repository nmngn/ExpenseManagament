//
//  BiggerHomeUserTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class BiggerHomeUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dayCreateLabel: UILabel!
    @IBOutlet weak var babyAgeLabel: UILabel!
    @IBOutlet weak var dateBornLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    
    var isStar: ((Bool) -> ())?
    var showInfo: ((Int) -> ())?
    var model : HomeModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
        subView.makeBorderColor()
        buttonCheck.titleLabel?.text = ""
        buttonCheck.adjustsImageWhenHighlighted = false
        buttonCheck.adjustsImageWhenDisabled = false
    }
    
    func setupData(model: HomeModel) {
        self.model = model
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = UIColor(red: 0.45, green: 0.66, blue: 0.85, alpha: 1.00)
        } else {
            subView.backgroundColor = UIColor(red: 0.36, green: 0.30, blue: 0.59, alpha: 1.00)
        }
        
        DispatchQueue.main.async {
            if !model.avatarImage.isEmpty {
            } else {
                self.avatarUser.image = UIImage(named: "avatar_placeholder")
            }
        }
        starImage.image = model.isStar ? UIImage(named: "star") : UIImage(named: "unstar")
        userNameLabel.text = model.name
        
        dayCreateLabel.text = model.dateSave
        
        if model.dateCalculate.isEmpty {
            babyAgeLabel.text = "Chưa cập nhật"
            dateBornLabel.text = "Chưa cập nhật"
        } else {
            babyAgeLabel.text = model.dateCalculate
            dateBornLabel.text = model.babyAge
        }
    }
    
    @IBAction func makeHightlight(_ sender: UIButton) {
        if let model = self.model {
            sender.isSelected = model.isStar ? false : true
        }
        starImage.image = sender.isSelected ? UIImage(named: "star") : UIImage(named: "unstar")
        isStar?(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func openNote(_ sender: UIButton) {
        if let week = model?.dateCalculate {
            if !week.isEmpty {
                let startIndex = week.index(week.startIndex, offsetBy: 0)
                let endIndex = week.index(week.startIndex, offsetBy: 1)
                let data = String(week[startIndex...endIndex])
                if let age = Int(data) {
                    showInfo?(age)
                }
            }
        }
    }
}
