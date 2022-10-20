//
//  NotificationViewController.swift
//  MoneyManager
//
//  Created by Nam Ngây on 29/12/2021.
//

import UIKit
import ESPullToRefresh
import Then

class NotificationViewController: UIViewController {

    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var titleBell: UILabel!
    
    var notiModel = [NotificationModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    let repo = Repositories(api: .share)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông báo"
        self.notiModel.removeAll()
        DispatchQueue.global(qos: .background).async {
            self.getListUser()
        }
        changeTheme(self.theme)
        configView()
        navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if notiModel.isEmpty {
            setupStatus(isHidden: false, title: "Không có thông báo nào")
        } else {
            setupStatus(isHidden: true, title: "")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
//        setupNavigationButton()
        tableView.reloadData()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: NotificationTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
            $0.es.addPullToRefresh {
                self.notiModel.removeAll()
                self.getListUser()
            }
        }
    }
    
    func getUserToPushNoti(listUser: [User]?) {
        tableView.es.stopPullToRefresh()
    }
    
    func getListUser() {
    }
    
    func setupStatus(isHidden: Bool, title: String) {
        bellView.isHidden = isHidden
        titleBell.text = title
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as?
                NotificationTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupData(model: self.notiModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
