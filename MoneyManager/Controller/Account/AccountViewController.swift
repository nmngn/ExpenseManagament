//
//  AccountViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 23/10/2022.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
    var dismissed: (() ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getDataUser()
    }
    
    func configView() {
        saveButton.isEnabled = false
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        birthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        moneyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let name = nameTextField.text, let birth = birthTextField.text, let money = moneyTextField.text {
            if !name.isEmpty && !birth.isEmpty && !money.isEmpty {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }
        resignFirstResponder()
    }
    
    func getDataUser() {
        repo.getOneUser(idUser: idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    self?.nameTextField.text = data.name
                    self?.birthTextField.text = data.birth
                    self?.moneyTextField.text = "\(data.money.formattedWithSeparator)"
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        dismissed?()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let money = (moneyTextField.text?.replacingOccurrences(of: ".", with: ""))!
        repo.updateUser(idUser: idUser,
                        name: nameTextField.text!,
                        birth: birthTextField.text!,
                        allMoney: Int(money) ?? 0) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    print(data)
                    self?.view.makeToast("Cập nhật thành công")
                    Session.shared.isPopToRoot = true
                    self?.dismiss(animated: true, completion: nil)
                    self?.dismissed?()
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
        }
    }
    
}
