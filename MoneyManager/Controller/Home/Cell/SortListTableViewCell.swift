//
//  SortListTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class SortListTableViewCell: UITableViewCell {

    var selectSoft : (() ->())?
    @IBOutlet weak var softTitle: UILabel!
    
    func setupTitle(title: String) {
        softTitle.text = title
    }
    
    @IBAction func selectSort(_ sender: UIButton) {
        selectSoft?()
    }
}
