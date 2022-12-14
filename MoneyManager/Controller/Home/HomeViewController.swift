//
//  ViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import NotificationCenter
import ESPullToRefresh
import Then

protocol HomeActionDelegete {
    func openProfile()
    func openDefaultExpense()
    func openFlexibleExpense()
    func reloadExpense() -> Bool
    func showAllRecent()
}

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
        
    var model = [HomeModel]()
    var expenseType = true
    var listTransaction: [Transaction]? {
        didSet {
            self.setupData(expenseType: self.expenseType)
        }
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
    var userModel = ("","",0) {
        didSet {
            self.setupData(expenseType: self.expenseType)
        }
    }
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        callApiRequest()
        userNotificationCenter.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.requestNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        if Session.shared.isPopToRoot {
            self.tableView.es.startPullToRefresh()
            Session.shared.isPopToRoot = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let listTransaction = listTransaction {
            let usedMoney = calculate(list: listTransaction)
            if (Double(usedMoney) / Double(userModel.2)) >= 0.9 {
                sendNotification()
            }
        }
    }

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification() {
        let application = UIApplication.shared
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Thông báo số tiền chi tiêu trong tháng"
        notificationContent.body =
        "Chú ý: Số tiền chi tiêu của bạn trong tháng đã đạt hơn 90%. Hãy cân nhắc !"
        
        application.applicationIconBadgeNumber = 1

        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
                
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func callApiRequest() {
        dispatchGroup.enter()
        self.getListTransaction()
        dispatchGroup.leave()
        dispatchGroup.enter()
        self.getDataUser()
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func getListTransaction() {
        repo.getAllTransaction(idUser: idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    if let list = data.transactions {
                        let curentDate = self?.getCurrentDate().prefix(7)
                        self?.listTransaction = list.filter({$0.dateTime.contains(curentDate ?? "")})
                    }
                }
            case .failure(let error):
                self?.openAlert(error?.errorMessage ?? "")
            }
            self?.tableView.es.stopPullToRefresh()
        }
    }
    
    func getDataUser() {
        repo.getOneUser(idUser: self.idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    self?.userModel = (data.idUser, data.name, data.money)
                }
            case .failure(let err):
                print(err as Any)
                self?.view.makeToast("Lỗi")
            }
            self?.tableView.es.stopPullToRefresh()
        }
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: WelcomeTableViewCell.self)
            $0.registerNibCellFor(type: BadgeTableViewCell.self)
            $0.registerNibCellFor(type: OptionTableViewCell.self)
            $0.registerNibCellFor(type: RecentTableViewCell.self)
            $0.registerNibCellFor(type: TransactionTableViewCell.self)
            $0.registerNibCellFor(type: BannerTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            $0.es.addPullToRefresh { [weak self] in
                self?.callApiRequest()
            }
        }
    }
    
    func setupData(expenseType: Bool) {
        model.removeAll()
        guard let listTransaction = listTransaction else {
            return
        }
        
        var welcome = HomeModel(type: .welcome)
        welcome.userName = userModel.1
        
        var badge = HomeModel(type: .badge)
        badge.allMoney = userModel.2
        badge.usedMoney = calculate(list: listTransaction)
        badge.calc()
        
        let option = HomeModel(type: .option)
        let showRecent = HomeModel(type: .showRecent)
        
        model.append(welcome)
        model.append(badge)
        model.append(option)
        model.append(showRecent)
        
        var transaction = HomeModel(type: .transaction)
        let newList = listTransaction.filter({$0.type == expenseType}).suffix(3)
        for item in newList.sorted(by: {$0.dateTime > $1.dateTime}) {
            transaction.transactionId = item.id
            transaction.category = item.category
            transaction.titleExpense = item.title
            transaction.timeExpense = item.dateTime
            transaction.moneyExpense = item.amount
            model.append(transaction)
        }
        let tutorial = HomeModel(type: .banner)
        model.append(tutorial)
        tableView.reloadData()
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return model[indexPath.row]
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .welcome:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeTableViewCell", for: indexPath) as?
                    WelcomeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            cell.delegate = self
            return cell
        case .badge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeTableViewCell", for: indexPath) as?
                    BadgeTableViewCell else { return UITableViewCell() }
            cell.setupData(data: model)
            cell.selectionStyle = .none
            return cell
        case .option:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as?
                    OptionTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .showRecent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell", for: indexPath) as?
                    RecentTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .transaction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as?
                    TransactionTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        case .banner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as?
                    BannerTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .transaction:
            let vc = TransactionDetailViewController.init(nibName: "TransactionDetailViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.idTransaction = model.transactionId
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: HomeActionDelegete {
    func openProfile() {
        let vc = AccountViewController.init(nibName: "AccountViewController", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        tabBarController?.tabBar.backgroundColor = UIColor.clear.withAlphaComponent(0.8)
        if let items = tabBarController?.tabBar.items {
                items.forEach { $0.isEnabled = false }
        }
        vc.dismissed = { [weak self] in
            if Session.shared.isPopToRoot {
                self?.tableView.es.startPullToRefresh()
                Session.shared.isPopToRoot = false
            }
            self?.tabBarController?.tabBar.backgroundColor = .white
            if let items = self?.tabBarController?.tabBar.items {
                    items.forEach { $0.isEnabled = true }
            }
        }
    }
    
    func openDefaultExpense() {
        let vc = ExpenseViewController.init(nibName: "ExpenseViewController", bundle: nil)
        vc.currentIndex = 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openFlexibleExpense() {
        let vc = ExpenseViewController.init(nibName: "ExpenseViewController", bundle: nil)
        vc.currentIndex = 1
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadExpense() -> Bool {
        if self.expenseType == true {
            setupData(expenseType: false)
            self.expenseType = false
            return true
        } else {
            setupData(expenseType: true)
            self.expenseType = true
            return true
        }
    }
    
    func showAllRecent() {
        let vc = ListTransactionViewController.init(nibName: "ListTransactionViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
