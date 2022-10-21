//
//  SmallOptionViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 19/01/2022.
//

import UIKit

class SmallOptionViewController: UIViewController {
    
    @IBOutlet weak var notiImage: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var theme: UIImageView!
    
    var navigation = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notiImage.image = UIImage(systemName: "bell")?.toHierachicalImage()
        theme.applyBlurEffect()
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        dismissView.addGestureRecognizer(tapGestureReconizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openNoti(_ sender: UIButton) {
    }
    
    func logOut() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.signOut()
        }
        let noAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
    }
    
    func popupErrorSignout() {
        let alert = UIAlertController(title: "Lỗi", message: "Đăng xuất lỗi", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openProfile(_ sender: UIButton) {

    }
        
    @IBAction func logOut(_ sender: UIButton) {
        logOut()
    }
}
