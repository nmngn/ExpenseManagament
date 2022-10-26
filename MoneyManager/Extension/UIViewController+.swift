//
//  UIViewController+.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 06/07/2022.
//

import UIKit

extension UIViewController {
    var appDelegate: SceneDelegate {
        return UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    }
    
    class func instantiateViewControllerFromStoryboard(storyboardName: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: self.className)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
    
    func transitionVC(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    
    func loading() {
        let alert = UIAlertController(title: nil, message: "Vui lòng đợi...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoading() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func calculate(list: [Transaction]) -> Int {
        var result = 0
        for item in list {
            result += item.amount
        }
        return result
    }
    
    func openAlert(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func mergeList(list: [Transaction]) -> [MergedDataModel] {
        var mergedModel = [MergedDataModel]()
        var newList = list
        
        var _ = newList.sorted { item1, item2 in
            if item1.category == item2.category {
                mergedModel.append(MergedDataModel(category: item1.category, amount: item1.amount + item2.amount))
                newList.removeAll(where: {$0.id == item1.id})
                newList.removeAll(where: {$0.id == item2.id})
            }
            return true
        }
        for item in newList {
            mergedModel.append(MergedDataModel(category: item.category, amount: item.amount))
        }
        return mergedModel
    }
}
