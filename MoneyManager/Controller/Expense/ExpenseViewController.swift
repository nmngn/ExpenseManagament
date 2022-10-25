//
//  ExpenseViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 21/10/2022.
//

import UIKit
import Parchment

class ExpenseViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!
    var pageTitles : [String] = ["Cố định", "Linh hoạt"]
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tổng hợp"
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        
        let startingViewController: ExpensePagingViewController = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

