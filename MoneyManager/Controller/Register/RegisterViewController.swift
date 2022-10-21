//
//  RegisterViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 21/10/2022.
//

import UIKit
import Toast_Swift

class RegisterViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    let repo = Repositories(api: .share)
    let sizeTextField = CGSize(width: UIScreen.main.bounds.width, height: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isEnabled = false
        nameTextField.delegate = self
        birthTextField.delegate = self
        moneyTextField.delegate = self
        navigationController?.isNavigationBarHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpAnimation()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    @IBAction func login() { //login user
        if let name = nameTextField.text, let birth = birthTextField.text, let money = moneyTextField.text {
            if !name.isEmpty && !birth.isEmpty && !money.isEmpty {
                repo.createUser(name: name, birth: birth, allMoney: Int(money) ?? 0) { data in
                    switch data {
                    case .success(let user):
                        if let user = user {
                            Session.shared.userProfile.idUser = user.idUser
                            Session.shared.userProfile.userName = user.name
                        }
                        self.animateAfterLogin()
                    case .failure(let err):
                        self.view.makeToast("Lỗi")
                        print(err)
                    }
                }
            } else {
                self.view.makeToast("Đang thiếu thông tin")
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = nameTextField.text, let birth = birthTextField.text, let money = moneyTextField.text {
            if !name.isEmpty && !birth.isEmpty && !money.isEmpty {
                startButton.isEnabled = true
            }
        }
        resignFirstResponder()
    }
}

// MARK: - SetupAnimation
extension RegisterViewController {
    
    func setUpUI() {
        logoImage.frame.size = CGSize(width: 100, height: 100)
        logoImage.center = view.center
        
        nameTextField.isHidden = true
        birthTextField.isHidden = true
        moneyTextField.isHidden = true
        
        nameTextField.do {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 12
            $0.setLeftPaddingPoints(12)
        }
        
        birthTextField.do {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 12
            $0.setLeftPaddingPoints(12)
        }
        moneyTextField.do {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 12
            $0.setLeftPaddingPoints(12)
        }

        nameTextField.frame = CGRect(x: 16, y: 220,
                                     width: sizeTextField.width, height: sizeTextField.height)
        birthTextField.frame = CGRect(x: 16, y: nameTextField.frame.maxY + 16,
                                      width: sizeTextField.width, height: sizeTextField.height)
        moneyTextField.frame = CGRect(x: 16, y: birthTextField.frame.maxY + 16,
                                      width: sizeTextField.width, height: sizeTextField.height)
        
        startButton.center.x = view.center.x
        startButton.isHidden = true
    }
    
    func setUpAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: []) {
            self.logoImage.center.y -= 300
        } completion: { _ in}
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.moneyTextField.isHidden = false
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1, options: []) {
            self.birthTextField.isHidden = false
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: []) {
            self.nameTextField.isHidden = false
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseInOut) {
            self.startButton.isHidden = false
        } completion: { _ in}
    }
    
    func animateAfterLogin() {
        view.endEditing(true)
        UIView.animate(withDuration: 1.5, delay: 0, options: []) {
            self.logoImage.center.y += 50
            self.logoImage.isHidden = true
        } completion: { _ in}
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.moneyTextField.isHidden = true
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1, options: []) {
            self.birthTextField.isHidden = true
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: []) {
            self.nameTextField.isHidden = true
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseInOut) {
            self.startButton.isHidden = true
        } completion: { _ in
            self.appDelegate.switchViewController(animation: true)
        }
    }
    
}

