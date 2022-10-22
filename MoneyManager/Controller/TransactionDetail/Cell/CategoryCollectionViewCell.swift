//
//  CategoryCollectionViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 22/10/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var categorySelected: (() ->())?
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.subView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                categorySelected?()
            } else {
                self.subView.backgroundColor = .clear
            }
        }
    }
    
    func compareCategory(ofIndex: String, ofData: String) {
        if ofIndex == ofData {
            self.subView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        } else {
            self.subView.backgroundColor = .clear
        }
    }
    
    func setupImage(image: String) {
        imageView.image = UIImage(named: image)
    }
}
