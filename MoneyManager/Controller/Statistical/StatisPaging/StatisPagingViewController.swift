//
//  StatisPagingViewController.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import UIKit

class StatisPagingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex = 0
    var listTransaction: [Transaction]? {
        didSet {
            self.setupData()
        }
    }
    let idUser = Session.shared.userProfile.idUser
    var model = [StatisPagingModel]()
    let repo = Repositories(api: .share)
    let date = Date()
    let mainThread = DispatchQueue.main
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        configView()
        mainThread.async {
            self.getData()
        }
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: BarChartTableViewCell.self)
            $0.registerNibCellFor(type: StatisMonthlyTableViewCell.self)
            $0.es.addPullToRefresh {
                self.getData()
            }
        }
    }
    
    func getData() {
        repo.getAllTransaction(idUser: self.idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data?.transactions {
                    let result = data.filter({$0.idUser == self?.idUser})
                    self?.listTransaction = result
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.reloadData()
        }
    }
    
    func getUserData() {
        repo.getOneUser(idUser: idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    self?.userData = data
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
        }
    }
    
    func checkDate(date: String) -> Bool {
        let dataYear = date[0 ..< 4]
        let dataMonth = date[5 ..< 7]
        
        if dataYear == "\(self.date.year)" && dataMonth == self.date.month {
            return true
        } else {
            return false
        }
    }
    
    func setupData() {
        guard let data = listTransaction else { return }
        guard let user = userData else {return}
        
        self.model.removeAll()
        
        var barChart = StatisPagingModel(type: .barChart)
        barChart.list = data
        
        var statis = StatisPagingModel(type: .info)
        statis.list = data
        statis.userData =
        
        model.append(barChart)
        model.append(statis)
        self.tableView.reloadData()
    }
    
    func modelIndexPath(indexPath: IndexPath) -> StatisPagingModel {
        return model[indexPath.row]
    }
    
}

extension StatisPagingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: StatisPagingModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .barChart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartTableViewCell", for: indexPath) as?
                    BarChartTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(list: model.list)
            return cell
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisMonthlyTableViewCell", for: indexPath) as?
                    StatisMonthlyTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(data: model.list)
            return cell
        }
    }
}
