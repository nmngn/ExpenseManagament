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
 
        IQKeyboardManager.shared.enableAutoToolbar = true
        UserDefaults.standard.synchronize()
        
        self.setupButtonAdd()
        self.setViewControllers(self.getTabbarViewController(), animated: true)
        self.delegate = self
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 28,
                                   y: self.view.bounds.height - 110,
                                   width: 56, height: 56)
    }
        
    func setupButtonAdd() {
        button.setImage(UIImage(named: "ic_add"), for: .normal)
        button.layer.cornerRadius = 32
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.4
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    
    @objc func addTransaction(_ sender: UIButton) {
        
    }
    
    func configureTabbarItem() {
        let itemHome = self.tabBar.items![0]
        itemHome.image = UIImage(systemName: "house")
        
        let itemTrans = self.tabBar.items![1]
        itemTrans.image = UIImage(systemName: "magnifyingglass")
        
        let itemPerformance = self.tabBar.items![2]
        itemPerformance.image = UIImage(systemName: "bell")
        
        let itemNotification = self.tabBar.items![3]
        itemNotification.image = UIImage(named: "person")
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
