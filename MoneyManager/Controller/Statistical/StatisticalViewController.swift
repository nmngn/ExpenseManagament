//
//  StatisticalViewController.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import UIKit

class StatisticalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pullDownButton: UIButton!
    
    var listTransaction: [Transaction]? {
        didSet {
            self.setupData()
        }
    }
    let idUser = Session.shared.userProfile.idUser
    var model = [StatisPagingModel]()
    let repo = Repositories(api: .share)
    let dispatchGroup = DispatchGroup()
    var userData: User? {
        didSet {
            self.setupData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thống kê"
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationButton()
        configView()
        callApiRequest(isFirst: true)
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: BarChartTableViewCell.self)
            $0.registerNibCellFor(type: StatisMonthlyTableViewCell.self)
            $0.es.addPullToRefresh { [weak self] in
                self?.callApiRequest()
            }
        }
    }
    
    func filterData(list: [Transaction]) -> [String] {
        var arrayDateData: [String] = []
        for item in list {
            let date = item.dateTime.prefix(7)
            if !arrayDateData.contains(where: {$0 == String(date)}) {
                arrayDateData.append(String(date))
            }
        }
        return arrayDateData
    }
    
    func setupButton(list: [Transaction]) {
        let listDate = filterData(list: list)
        var listChildren: [UIAction] = []
        
        let menuClosure = {(action: UIAction) in
            self.loadDataOfMonth(value: action.title)
        }
        let newListDate = listDate.sorted(by: {$0 > $1})
        
        for value in newListDate {
            listChildren.append(UIAction(title: value, handler: menuClosure))
        }

        pullDownButton.menu = UIMenu(children: listChildren)
        pullDownButton.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            pullDownButton.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func loadDataOfMonth(value: String) {
        self.callApiRequest(date: value)
        self.view.makeToast(value)
    }
    
    func callApiRequest(date: String? = nil, isFirst: Bool = false) {
        dispatchGroup.enter()
        self.getUserData()
        dispatchGroup.leave()
        dispatchGroup.enter()
        self.getData(date: date, isFirst: isFirst)
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func getData(date: String? = nil, isFirst: Bool) {
        repo.getAllTransaction(idUser: self.idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data?.transactions {
                    let result = data
                    if let date = date {
                        let newResult = result.filter({$0.dateTime.contains(String(date))})
                        self?.listTransaction = newResult
                    } else {
                        let currentDate = self?.getCurrentDate().prefix(7)
                        let newResult = result.filter({$0.dateTime.contains(String(currentDate ?? ""))})
                        self?.listTransaction = newResult
                    }
                    if isFirst {
                        self?.setupButton(list: result)
                    }
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
            self?.tableView.es.stopPullToRefresh()
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
            self?.tableView.es.stopPullToRefresh()
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
        statis.userData = user
        
        model.append(barChart)
        model.append(statis)
        self.tableView.reloadData()
    }
    
    func modelIndexPath(indexPath: IndexPath) -> StatisPagingModel {
        return model[indexPath.row]
    }
    
}

extension StatisticalViewController: UITableViewDelegate, UITableViewDataSource {
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
            if let data = model.userData {
                cell.setupData(data: model.list, user: data)
            }
            return cell
        }
    }
}
