//
//  ExpensePagingViewController.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 24/10/2022.
//

import UIKit
import SwiftUI

class ExpensePagingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex : Int = 0
    var titleText : String = ""
    
    var expenseModel = [ExpenseModel]()
    var listTransaction: [Transaction]? {
        didSet {
            setupData()
        }
    }
    var userData: User? {
        didSet {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    var idUser = Session.shared.userProfile.idUser
    let repo = Repositories(api: .share)
    let utilityThread = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tổng hợp"
        configView()
        getDataUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        var filter = true
        if pageIndex == 1 {
            filter = false
        }
        
        repo.getAllTransaction(idUser: idUser) { value in
            switch value{
            case .success(let data):
                if let data = data?.transactions {
                    self.listTransaction = data.filter({$0.idUser == self.idUser && $0.type == filter})
                }
            case .failure(let err):
                print(err as Any)
            }
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func getDataUser() {
        utilityThread.async {
            self.repo.getOneUser(idUser: self.idUser) { value in
                switch value {
                case .success(let data):
                    if let data = data {
                        self.userData = data
                    }
                case .failure(let err):
                    print(err as Any)
                }
            }
        }
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
            $0.registerNibCellFor(type: PieChartTableViewCell.self)
            $0.registerNibCellFor(type: ItemTableViewCell.self)
            $0.registerNibCellFor(type: AddTransactionTableViewCell.self)
            $0.registerNibCellFor(type: StatisTableViewCell.self)
            $0.es.addPullToRefresh {
                self.getData()
            }
        }
    }
    
    func setupData() {
        guard let list = self.listTransaction else {return }
        expenseModel.removeAll()
        
        var chart = ExpenseModel(type: .pieChart)
        chart.listData = list
        chart.usedMoney = calculate(list: list)
        expenseModel.append(chart)
        
        var statis = ExpenseModel(type: .statis)
        statis.allMoney = userData?.money ?? 0
        statis.usedMoney = calculate(list: list)
        expenseModel.append(statis)
        
        var item = ExpenseModel(type: .item)
        for data in list {
            item.id = data.id
            item.category = data.category
            item.title = data.title
            item.date = data.dateTime
            item.amount = data.amount
            item.description = data.description
            expenseModel.append(item)
        }
        
        let add = ExpenseModel(type: .add)
        expenseModel.append(add)
        self.tableView.reloadData()
    }
    
    func modelIndexPath(indexPath: IndexPath) -> ExpenseModel {
        return expenseModel[indexPath.row]
    }

}

extension ExpensePagingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: ExpenseModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .pieChart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTableViewCell", for: indexPath) as? PieChartTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(data: mergeList(list: model.listData), usedMoney: model.usedMoney)
            return cell
        case .statis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisTableViewCell", for: indexPath) as? StatisTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(usedMoney: model.usedMoney, allMoney: model.allMoney)
            return cell
        case .item:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(data: model)
            return cell
        case .add:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as? AddTransactionTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: ExpenseModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .item:
            let vc = TransactionDetailViewController.init(nibName: "TransactionDetailViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.idTransaction = model.id
            self.navigationController?.pushViewController(vc, animated: true)
        case .add:
            let vc = TransactionDetailViewController.init(nibName: "TransactionDetailViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.typeExpense = pageIndex
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
