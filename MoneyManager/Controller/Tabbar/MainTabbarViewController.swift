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
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
    }
        
    func setupButtonAdd() {
        button.setTitle("Cam", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        
        button.backgroundColor = .orange
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.yellow.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        button.addTarget(self, action: #selector(addTransaction()), for: .touchUpInside)
    }
    
    @objc func addTransaction() {
        
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
        expense.tabBarItem = ESTabBarItem.init(ESTabbarBasicContentView(),title: "Tìm kiếm", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill")?.toHierachicalImage())
        
        let notiVC = UINavigationController(rootViewController: NotificationViewController.init(nibName: "NotificationViewController", bundle: nil))
        notiVC.tabBarItem = ESTabBarItem.init(ESTabbarBasicContentView(), title: "Thông báo", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill")?.toHierachicalImage())
        
        let account = UINavigationController(rootViewController: AccountViewController.init(nibName: "AccountViewController", bundle: nil))
        account.tabBarItem = ESTabBarItem.init(ESTabbarBasicContentView(), title: "Thông tin cá nhân".localized, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill")?.toHierachicalImage())

        viewController.append(contentsOf: [homeVC, expense, notiVC, account])
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
