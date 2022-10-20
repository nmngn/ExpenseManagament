//
//  PopupInfoViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 04/01/2022.
//

import UIKit

class PopupInfoViewController: UIViewController {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var age = 0 {
        didSet {
            setupData()
        }
    }
    
    var text = "" {
        didSet {
            setupData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        if weekLabel == nil {
            return
        }
        weekLabel?.text = "Tuần thai thứ \(age)"
        descriptionLabel?.text = text
    }
}
