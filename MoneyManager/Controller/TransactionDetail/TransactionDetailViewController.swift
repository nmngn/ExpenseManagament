//
//  TransactionDetailViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 21/10/2022.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var buttonAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func add(_ sender: UIButton) {
        
    }
}
