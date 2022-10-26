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
    
    var typeExpense = 0
    var modelCategory = ["car", "device", "health", "house", "office", "food", "shopping", "other"]
    var category = ""
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
    var oldIndexPath = 0
    var idTransaction: String = "" {
        didSet {
            if !idTransaction.isEmpty {
                self.getDataTransaction(transactionId: idTransaction)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiêu"
        configView()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationButton()
        buttonAction.isEnabled = false
        self.buttonAction.setTitle("Lưu", for: .normal)
    }
    
    func configView() {
        segmentType.selectedSegmentIndex = typeExpense
        segmentType.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        titleTextField.do {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            $0.setLeftPaddingPoints(12)
            $0.autocorrectionType = .no
        }
        
        amountTextField.do {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            $0.setLeftPaddingPoints(12)
        }
        descriptionTextView.do {
            $0.delegate = self
            $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.autocorrectionType = .no
            $0.isScrollEnabled = false
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.checkButtonState()
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
        checkButtonState()
        resignFirstResponder()
    }
    
    func checkButtonState() {
        if let title = titleTextField.text, let amount = amountTextField.text {
            if !title.isEmpty && !amount.isEmpty && !category.isEmpty {
                if (Int(amount) != nil) {
                    buttonAction.isEnabled = true
                } else {
                    buttonAction.isEnabled = false
                }
            }
        }
    }
    
    func getDataTransaction(transactionId: String) {
        self.repo.getOneTransaction(transactionId: transactionId) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    self?.titleTextField.text = data.title
                    self?.amountTextField.text = "\(data.amount)"
                    self?.descriptionTextView.text = data.description
                    self?.category = data.category
                    if data.type {
                        self?.segmentType.selectedSegmentIndex = 0
                    } else {
                        self?.segmentType.selectedSegmentIndex = 1
                    }
                    if !(self?.descriptionTextView.text.isEmpty ?? false) {
                        self?.placeholderLabel.text = ""
                    } else {
                        self?.placeholderLabel.text = "Nhập ghi chú"
                    }
                    self?.collectionView.reloadData()
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
        }
        
    }
    
    @IBAction func add(_ sender: UIButton) {
        if idTransaction.isEmpty {
            self.repo.createTransaction(idUser: self.idUser,
                                        title: self.titleTextField.text!,
                                        description: self.descriptionTextView.text ?? "",
                                        amount: Int(self.amountTextField.text!) ?? 0,
                                        category: self.category,
                                        dateTime: self.getCurrentDate(),
                                        isIncome: false,
                                        type: self.segmentType.selectedSegmentIndex == 0 ? true : false) { [weak self] value in
                switch value {
                case .success(let data):
                    if let data = data {
                        print(data)
                        self?.view.makeToast("Lưu thành công")
                        Session.shared.isPopToRoot = true
                        self?.navigationController?.popViewController(animated: true)
                        self?.dismiss(animated: true, completion: nil)
                    }
                case .failure(let err):
                    if let err = err {
                        print(err)
                        self?.view.makeToast("Lỗi")
                    }
                }
            }
        } else {
            self.repo.updateTransaction(transactionId: idTransaction,
                                        title: self.titleTextField.text!,
                                        description: self.descriptionTextView.text ?? "",
                                        amount: Int(self.amountTextField.text!) ?? 0,
                                        category: self.category,
                                        isIncome: false,
                                        type: self.segmentType.selectedSegmentIndex == 0 ? true : false) { [weak self] value in
                switch value {
                case .success(let data):
                    if let data = data {
                        print(data)
                        self?.view.makeToast("Lưu thành công")
                        Session.shared.isPopToRoot = true
                        self?.navigationController?.popViewController(animated: true)
                        self?.dismiss(animated: true, completion: nil)
                    }
                case .failure(let err):
                    if let err = err {
                        print(err)
                        self?.view.makeToast("Lỗi")
                    }
                }
            }
        }
    }
}

extension TransactionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as?
                CategoryCollectionViewCell else {return UICollectionViewCell()}
        cell.setupImage(image: modelCategory[indexPath.row])
        cell.compareCategory(ofIndex: modelCategory[indexPath.row], ofData: self.category)
        if modelCategory[indexPath.row] == self.category {
            self.oldIndexPath = indexPath.row
        }
        cell.categorySelected = { [weak self] in
            self?.category = (self?.modelCategory[indexPath.row])!
            self?.checkButtonState()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: IndexPath(row: self.oldIndexPath, section: 0))
        cell?.isSelected = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 10.0
        let numberOfItemsPerRow: CGFloat = 4.0
        
        let width = (collectionView.frame.width - leftAndRightPaddings - 15) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
}

extension TransactionDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if !text.isEmpty {
                placeholderLabel.text = ""
            } else {
                placeholderLabel.text = "Nhập ghi chú"
            }
        }
        self.checkButtonState()
    }
}
