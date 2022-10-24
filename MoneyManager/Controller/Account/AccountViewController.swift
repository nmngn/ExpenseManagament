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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        repo.getOneUser(idUser: idUser) { value in
            switch value {
            case .success(let data):
                if let data = data {
                    self.nameTextField.text = data.name
                    self.birthTextField.text = data.birth
                    self.moneyTextField.text = "\(data.money)"
                }
            case .failure(let err):
                print(err as Any)
            }
        }
    }

    @IBAction func saveAction(_ sender: UIButton) {
        repo.updateUser(idUser: idUser,
                        name: nameTextField.text!,
                        birth: birthTextField.text!,
                        allMoney: Int(moneyTextField.text!) ?? 0) { value in
            switch value {
            case .success(let data):
                if let data = data {
                    print("update success")
                    self.view.makeToast("Cập nhật thành công")
                    Session.shared.isPopToRoot = true
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let err):
                print(err as Any)
            }
        }
    }
    
}
