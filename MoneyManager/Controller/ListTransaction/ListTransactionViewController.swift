//
//  ListTransactionViewController.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 22/10/2022.
//

import UIKit

class ListTransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var listTransaction: [Transaction]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
    let mainThread = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Danh sách chi tiêu"
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        configView()
        mainThread.async {
            self.getListData()
        }
        setupNavigationButton()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.es.startPullToRefresh()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.registerNibCellFor(type: TransactionTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.es.addPullToRefresh { [weak self] in
                self?.getListData()
            }
        }
    }
    
    func getListData() {
        repo.getAllTransaction(idUser: idUser) {[weak self] value in
            switch value {
            case .success(let data):
                if let list = data?.transactions {
                    self?.listTransaction = list.filter({$0.type == (self?.segmentControl.selectedSegmentIndex == 0 ? true : false)}).sorted(by: {$0.dateTime > $1.dateTime})
                }
            case .failure(let err):
                if let err = err {
                    print(err)
                    self?.view.makeToast("Lỗi")
                }
            }
            self?.tableView.es.stopPullToRefresh()
        }
    }
    
    func removeTransaction(id: String) {
        repo.deleteTransaction(transactionId: id) { response in
            switch response {
            case .success(let value):
                print(value as Any)
                self.view.makeToast("Xoá thành công")
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        mainThread.async {
            self.getListData()
        }
    }
}

extension ListTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTransaction?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as?
                TransactionTableViewCell else { return UITableViewCell() }
        if let list = listTransaction {
            cell.setupData(model: list[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionDetailViewController.init(nibName: "TransactionDetailViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        vc.idTransaction = self.listTransaction?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            removeTransaction(id: self.listTransaction?[indexPath.row].id ?? "")
            self.listTransaction?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            mainThread.async {
                self.getListData()
            }
            Session.shared.isPopToRoot = true
        }
    }
}
