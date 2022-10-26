//
//  ExpenseViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 21/10/2022.
//

import UIKit
import Parchment

class ExpenseViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController : UIPageViewController!
    var statusView = UIView()
    var statusText = UILabel()
    var statusLine = UILabel()
    
    var pageTitles: [String] = ["Cố định", "Linh hoạt"]
    var currentIndex: Int = 0
        
    override func loadView() {
        super.loadView()
        statusView.frame = CGRect(x: 0, y: 91, width: UIScreen.main.bounds.width, height: 44)
        statusView.backgroundColor = .white
        
        statusText.frame = CGRect(x: 16, y: 11,
                                  width: (self.statusView.frame.width - 64) / 2, height: 20)
        statusText.textAlignment = .center
        statusText.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        statusText.text = pageTitles[0]
        
        statusLine.frame = CGRect(x: 16, y: 43,
                                  width: (self.statusView.frame.width - 64) / 2, height: 1)
        statusLine.backgroundColor = UIColor(red: 0.21, green: 0.50, blue: 0.35, alpha: 1.00)
        
        self.view.addSubview(statusView)
        statusView.addSubview(statusText)
        statusView.addSubview(statusLine)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tổng hợp"
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingViewController: ExpensePagingViewController = viewControllerAtIndex(index: currentIndex)!
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 135, width: view.frame.size.width, height: view.frame.size.height - 135);

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
                
        navigationController?.isNavigationBarHidden = false
        if self.navigationController?.viewControllers.count != 1 {
            setupNavigationButton()
        }
        rightBarItem()
    }
    
    private func rightBarItem() {
        let actionButton = UIBarButtonItem(image: UIImage(named: "ic_statis")?.toHierachicalImage(), style: .plain, target: self, action: #selector(handleButton))
        self.navigationItem.rightBarButtonItem  = actionButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeTab()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleButton() {
        let vc = StatisPagingViewController.init(nibName: "StatisPagingViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ExpensePagingViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ExpensePagingViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> ExpensePagingViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = ExpensePagingViewController()
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    func changeTab() {
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.statusText.frame = CGRect(x: 16, y: 11,
                                          width: (self.statusView.frame.width - 64) / 2, height: 20)
                self.statusText.textAlignment = .center
                self.statusText.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                self.statusText.text = self.pageTitles[0]
                
                self.statusLine.frame = CGRect(x: 16, y: 43,
                                          width: (self.statusView.frame.width - 64) / 2, height: 1)
                self.statusLine.backgroundColor = UIColor(red: 0.21, green: 0.50, blue: 0.35, alpha: 1.00)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.statusText.frame = CGRect(x: (self.view.frame.width - 16 - ((self.statusView.frame.width - 64) / 2)), y: 11,
                                          width: (self.statusView.frame.width - 64) / 2, height: 20)
                self.statusText.textAlignment = .center
                self.statusText.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                self.statusText.text = self.pageTitles[1]
                
                self.statusLine.frame = CGRect(x: (self.view.frame.width - 16 - ((self.statusView.frame.width - 64) / 2)), y: 43,
                                          width: (self.statusView.frame.width - 64) / 2, height: 1)
                self.statusLine.backgroundColor = UIColor(red: 0.21, green: 0.50, blue: 0.35, alpha: 1.00)
            }
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! ExpensePagingViewController
        self.currentIndex = pageContentViewController.pageIndex
        changeTab()
    }
}

