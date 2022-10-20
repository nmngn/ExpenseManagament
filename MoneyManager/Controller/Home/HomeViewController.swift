//
//  ViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import NotificationCenter
import SwiftCSV
import PopupDialog
import Presentr
import ESPullToRefresh
import Then

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
        
    var model = [HomeModel]()
    var listUser: [User]? {
        didSet {
            self.setupData()
        }
    }
    var sortType = ""
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notiModel = [NotificationModel]()
    let repo = Repositories(api: .share)
    let idUser = Session.shared.userProfile.idUser
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
        self.title = "Màn hình chính"
        changeTheme(theme)
        configView()
        utilityThread.async {
            self.getListUser()
        }
//        setupNavigationButton()
        userNotificationCenter.delegate = self
        navigationController?.isNavigationBarHidden = false
        self.requestNotificationAuthorization()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
//        setupNavigationButton()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Session.shared.isPopToRoot {
            utilityThread.async {
                self.getListUser()
            }
            Session.shared.isPopToRoot = false
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationButton() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.toHierachicalImage()
                                        , style: .plain, target: self, action: #selector(openMore))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func openMore() {
        let vc = SmallOptionViewController.init(nibName: "SmallOptionViewController", bundle: nil)
        vc.notiModel = self.notiModel
        vc.navigation = self.navigationController ?? UINavigationController()
        customPresentViewController(presenter, viewController: vc, animated: true)
    }

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(noti: [NotificationModel]) {
        let application = UIApplication.shared
        let notificationContent = UNMutableNotificationContent()
        if noti.count == 1 {
            notificationContent.title = "Thông báo về: \(noti.first?.name ?? "")"
            guard let date = noti.first?.dateCalculate else { return }
            if date.contains("40W") {
                notificationContent.body =
                "Chú ý: \(noti.first?.name ?? "") đã đủ 40 tuần. Hãy chú ý !"
            } else {
                notificationContent.body =
                "Chú ý: \(noti.first?.name ?? "") đã bước vào tháng cuối( \(noti.first?.dateCalculate ?? ""))\nCần chú ý !"
            }
        } else {
            notificationContent.title = "Thông báo về \(self.notiModel.count) sản phụ tháng cuối"
            notificationContent.body =
            "Chú ý: \(self.notiModel.count) sản phụ đã bước vào tháng cuối \nCần chú ý !"
        }
        application.applicationIconBadgeNumber = noti.count
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var date = DateComponents()
        date.hour = 7
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        if !noti.isEmpty {
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = NotificationViewController.init(nibName: "NotificationViewController", bundle: nil)
        vc.notiModel = self.notiModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func getUserToPushNoti(listUser: [User]?) {
        self.notiModel.removeAll()
        if let listUser = listUser {
            let newList = listUser.filter ({ user in
                let text = updateTime(dateString: user.babyDateBorn)
                if !text.isEmpty {
                    let wStartIndex = text.index(text.startIndex, offsetBy: 0)
                    let wEndIndex = text.index(text.startIndex, offsetBy: 1)
                    let weekData = String(text[wStartIndex...wEndIndex])
                    
                    let wResult = Int(weekData) ?? 0 >= 38
                    return wResult
                }
                return false
            })
            for user in newList {
                self.notiModel.append(user.convertToNotiModel())
            }
            self.sendNotification(noti: self.notiModel)
        }
    }
    
    func getListUser(reverse: Bool = false) {
        repo.getAllUser(idAdmin: idAdmin) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    let list = data.users?.filter({$0.idAdmin == self?.idAdmin})
                    self?.getUserToPushNoti(listUser: list)
                    if !reverse {
                        self?.listUser = list
                    } else {
                        self?.listUser = list?.reversed()
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
            $0.registerNibCellFor(type: BadgeUserTableViewCell.self)
            $0.registerNibCellFor(type: HomeTitleTableViewCell.self)
            $0.registerNibCellFor(type: SortListTableViewCell.self)
            $0.registerNibCellFor(type: AddUserTableViewCell.self)
            $0.registerNibCellFor(type: BiggerHomeUserTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
            $0.es.addPullToRefresh {
                self.sortType = "Sắp xếp"
                self.getListUser()
            }
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listUser = self.listUser else { return }
        
        let badge = HomeModel(type: .badge)
        let addUser = HomeModel(type: .addUser)
        
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này(\(newList.count))"
        
        var infoCell = HomeModel(type: .infoUser)
        let sort = HomeModel(type: .sort)
        
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả sản phụ(\(listUser.count))"
        
        model.append(badge)
        model.append(addUser)
        model.append(header1)
        
        for i in 0..<newList.count {

            model.append(infoCell)
        }
        
        model.append(header2)
        if !listUser.isEmpty {
            model.append(sort)
        }
        
        for i in 0..<listUser.count {
            model.append(infoCell)
        }
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
        case .badge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeUserTableViewCell", for: indexPath) as?
                    BadgeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let list = self.listUser {
                cell.getNumberPatient(list: list)
            }
            return cell
        case .addUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserTableViewCell", for: indexPath) as?
                    AddUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData()
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiggerHomeUserTableViewCell", for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                cell.setupData(model: model)
            }
            cell.isStar = { [weak self] isStar in
                self?.saveStarStatus(id: model.id, isStar)
            }
            cell.showInfo = { [weak self] age in
                self?.getAgeData(age)
            }
            return cell
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortListTableViewCell", for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            self.sortType == "" ? cell.setupTitle(title: "Sắp xếp") : cell.setupTitle(title: self.sortType)
            cell.selectSoft = { [weak self] in
                self?.sortListUser()
            }
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTitleTableViewCell", for: indexPath) as?
                    HomeTitleTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        

        default:
            break
        }
    }
    
}
