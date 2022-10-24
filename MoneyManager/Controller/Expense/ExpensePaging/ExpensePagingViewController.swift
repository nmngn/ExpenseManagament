//
//  ExpensePagingViewController.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 24/10/2022.
//

import UIKit

class ExpensePagingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var expenseModel = [ExpenseModel]()
    var listTransaction: [Transaction]?
    var idUser = Session.shared.userProfile.idUser
    let repo = Repositories(api: .share)
    let utilityThread = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: PieChartTableViewCell.self)
            $0.registerNibCellFor(type: ItemTableViewCell.self)
            $0.registerNibCellFor(type: AddTransactionTableViewCell.self)
        }
    }
    
    func setupData() {
        expenseModel.removeAll()
        
        var chart = ExpenseModel(type: .pieChart)
        var item = ExpenseModel(type: .item)
        var add = ExpenseModel(type: .add)
        
        expenseModel.append(chart)
        expenseModel.append(item)
        expenseModel.append(add)
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
            return cell
        case .item:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
        case .add:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell", for: indexPath) as? AddTransactionTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
