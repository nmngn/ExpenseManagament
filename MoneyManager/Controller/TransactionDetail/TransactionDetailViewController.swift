//
//  TransactionDetailViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 21/10/2022.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomTextViewHeight: NSLayoutConstraint!
    
    var modelCategory = ["car", "device", "health", "house", "office", "food", "shopping", "other"]
    var expenseType: Bool = false
    var categorySelected = ""
    let repo = Repositories(api: .share)
    let utilityThread = DispatchQueue.global(qos: .utility)
    let idUser = Session.shared.userProfile.idUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiêu"
        configView()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationButton()
        buttonAction.isEnabled = false
    }
    
    func configView() {
        segmentType.selectedSegmentIndex = 0
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.setLeftPaddingPoints(12)
        titleTextField.autocorrectionType = .no
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.setLeftPaddingPoints(12)
        
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.autocorrectionType = .no
        descriptionTextView.isScrollEnabled = false
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomTextViewHeight.constant = keyboardHeight - 18
            self.collectionViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomTextViewHeight.constant = 16
        self.collectionViewHeight.constant = 244
        self.view.layoutIfNeeded()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let title = titleTextField.text, let amount = amountTextField.text {
            if !title.isEmpty && !amount.isEmpty && !categorySelected.isEmpty {
                if (Int(amount) != nil) {
                    buttonAction.isEnabled = true
                } else {
                    buttonAction.isEnabled = false
                }
            }
        }
        resignFirstResponder()
    }
    
    @IBAction func add(_ sender: UIButton) {
        repo.createTransaction(idUser: idUser,
                               title: titleTextField.text!,
                               description: descriptionTextView.text ?? "",
                               amount: Int(amountTextField.text!) ?? 0,
                               category: categorySelected,
                               dateTime: getCurrentDate(),
                               isIncome: false,
                               type: segmentType.selectedSegmentIndex == 0 ? true : false) { value in
            switch value {
            case .success(let data):
                if let data = data {
                    print(data)
                    self.view.makeToast("Lưu thành công")
                    Session.shared.isPopToRoot = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let err):
                if let err = err {
                    print(err)
                    self.view.makeToast("Lỗi")
                }
            }
        }
    }
}

extension TransactionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as?
                CategoryCollectionViewCell else {return UICollectionViewCell()}
        cell.setupImage(image: modelCategory[indexPath.row])
        cell.categorySelected = { [weak self] in
            self?.categorySelected = (self?.modelCategory[indexPath.row])!
        }
        return cell
    }
}

extension TransactionDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if !text.isEmpty {
                placeholderLabel.text = ""
            } else {
                placeholderLabel.text = "Nhập ghi chú"
            }
        }
    }
}
