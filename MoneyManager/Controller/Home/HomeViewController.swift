//
//  ViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import NotificationCenter
import PopupDialog
import Presentr
import ESPullToRefresh
import Then

protocol HomeActionDelegete {
    func openProfile()
    func openDefaultExpense()
    func openFlexibleExpense()
    func reloadExpense()
    func showAllRecent()
}

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
        
    var model = [HomeModel]()
    var listTransaction: [Transaction]? {
        didSet {
            self.setupData()
        }
    }
    var userData: User?
    let userNotificationCenter = UNUserNotificationCenter.current()
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
    let userMoney = Session.shared.userProfile.money
    let utilityThread = DispatchQueue.global(qos: .utility)
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .coverHorizontalFromRight
        customPresenter.dismissTransitionType = .coverHorizontalFromRight
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissAnimated = true
        customPresenter.dismissOnSwipeDirection = .default
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        utilityThread.async {
            self.getListTransaction()
        }
        userNotificationCenter.delegate = self
        navigationController?.isNavigationBarHidden = true
        self.requestNotificationAuthorization()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Session.shared.isPopToRoot {
            utilityThread.async {
                self.getListTransaction()
            }
            Session.shared.isPopToRoot = false
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
//    func sendNotification(noti: [NotificationModel]) {
//        let application = UIApplication.shared
//        let notificationContent = UNMutableNotificationContent()
//        if noti.count == 1 {
//            notificationContent.title = "Thông báo về: \(noti.first?.name ?? "")"
//            guard let date = noti.first?.dateCalculate else { return }
//            if date.contains("40W") {
//                notificationContent.body =
//                "Chú ý: \(noti.first?.name ?? "") đã đủ 40 tuần. Hãy chú ý !"
//            } else {
//                notificationContent.body =
//                "Chú ý: \(noti.first?.name ?? "") đã bước vào tháng cuối( \(noti.first?.dateCalculate ?? ""))\nCần chú ý !"
//            }
//        } else {
//            notificationContent.title = "Thông báo về \(self.notiModel.count) sản phụ tháng cuối"
//            notificationContent.body =
//            "Chú ý: \(self.notiModel.count) sản phụ đã bước vào tháng cuối \nCần chú ý !"
//        }
//        application.applicationIconBadgeNumber = noti.count
//
//        if let url = Bundle.main.url(forResource: "dune",
//                                     withExtension: "png") {
//            if let attachment = try? UNNotificationAttachment(identifier: "dune",
//                                                              url: url,
//                                                              options: nil) {
//                notificationContent.attachments = [attachment]
//            }
//        }
//
//        var date = DateComponents()
//        date.hour = 7
//        date.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: "Notification",
//                                            content: notificationContent,
//                                            trigger: trigger)
//
//        if !noti.isEmpty {
//            userNotificationCenter.add(request) { (error) in
//                if let error = error {
//                    print("Notification Error: ", error)
//                }
//            }
//        }
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func getListTransaction() {
        repo.getAllTransaction(idUser: idUser) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    if let list = data.transactions?.filter({$0.idUser == self?.idUser}) {
                        self?.listTransaction = list
                    }
                }
            case .failure(let error):
                self?.openAlert(error?.errorMessage ?? "")
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
            $0.es.addPullToRefresh {
                self.getListTransaction()
            }
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listTransaction = listTransaction else {
            return
        }
        
        let welcome = HomeModel(type: .welcome)
        var badge = HomeModel(type: .badge)
        badge.allMoney = userMoney
        badge.usedMoney = 100000
        badge.calc()
        
        let option = HomeModel(type: .option)
        let showRecent = HomeModel(type: .showRecent)
        let tran1 = HomeModel(type: .transaction)
        let tran2 = HomeModel(type: .transaction)

        let tutorial = HomeModel(type: .banner)
         
        model.append(welcome)
        model.append(badge)
        model.append(option)
        model.append(showRecent)
        model.append(tran1)
        model.append(tran2)
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
    }
}

extension HomeViewController: HomeActionDelegete {
    func openProfile() {
        
    }
    
    func openDefaultExpense() {
        
    }
    
    func openFlexibleExpense() {
        
    }
    
    func reloadExpense() {
        
    }
    
    func showAllRecent() {
        
    }
}
