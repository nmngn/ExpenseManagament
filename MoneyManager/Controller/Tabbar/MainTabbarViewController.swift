//
//  MainTabbarViewController.swift
//  MicroInvestment
//
//  Created by Trung Hoang Van on 12/19/19.
//  Copyright © 2019 Funtap JSC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ESTabBarController_swift

class MainTabbarViewController: ESTabBarController, UITabBarControllerDelegate {
    
    let button = UIButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAdd()
        IQKeyboardManager.shared.enableAutoToolbar = true
        UserDefaults.standard.synchronize()
        self.setViewControllers(self.getTabbarViewController(), animated: true)
        self.delegate = self
        self.view.backgroundColor = .white
    }
    
    func setupButtonAdd() {
        button.setImage(UIImage(named: "ic_add"), for: .normal)
        button.layer.cornerRadius = 28
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.4
        button.frame = CGRect.init(x: self.tabBar.center.x - 28,
                                   y: -15,
                                   width: 56, height: 56)
        self.tabBar.addSubview(button)
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    
    @objc func addTransaction(_ sender: UIButton) {
        let vc = TransactionDetailViewController.init(nibName: "TransactionDetailViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated:true, completion: nil)
    }
    
    func configureTabbarItem() {
        let itemHome = self.tabBar.items![0]
        itemHome.image = UIImage(systemName: "house")
        
        let itemTrans = self.tabBar.items![1]
        itemTrans.image = UIImage(systemName: "wallet.pass")
    }
    
    func getTabbarViewController() -> [UIViewController] {
        var viewController = [UIViewController]()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController.init(nibName: "Home", bundle: nil))
        homeVC.tabBarItem = ESTabBarItem.init(ESTabbarBasicContentView(), title: "Màn hình chính", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill")?.toHierachicalImage())
        
        let expense = UINavigationController(rootViewController: ExpenseViewController.init(nibName: "ExpenseViewController", bundle: nil))
        expense.tabBarItem = ESTabBarItem.init(ESTabbarBasicContentView(),title: "Tổng hợp", image: UIImage(systemName: "wallet.pass"), selectedImage: UIImage(systemName: "wallet.pass")?.toHierachicalImage())
        
        viewController.append(contentsOf: [homeVC, expense])
        return viewController
    }
}

class ESTabbarBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .black
        highlightTextColor = .systemBlue
        iconColor = .black
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
