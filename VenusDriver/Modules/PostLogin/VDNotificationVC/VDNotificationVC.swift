//
//  VDNotificationVC.swift
//  VenusDriver
//
//  Created by Amit on 14/06/23.
//

import UIKit

class VDNotificationVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!


    var notificationViewModel: VDNotificationViewModel = VDNotificationViewModel()

    var notificationList = [NotificationDetails]()

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDNotificationVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self

        notificationTableView.register(UINib(nibName: "VDNotificationCell", bundle: nil), forCellReuseIdentifier: "VDNotificationCell")
        notificationTableView.register(UINib(nibName: "VDNotificationHeaderCell", bundle: nil), forCellReuseIdentifier: "VDNotificationHeaderCell")

        notificationViewModel.fetchNotificationList()

        notificationViewModel.notificationListSuccessCallBack = { list in
            self.notificationList = list
            self.notificationTableView.reloadData()
        }

    }

    @IBAction func btnSideMenu(_ sender: Any) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.showLeftView()
    }
}

extension VDNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLbl.isHidden = (notificationList.count != 0)
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDNotificationCell", for: indexPath) as? VDNotificationCell
        cell?.updateCell(notificationList[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDNotificationHeaderCell") as? VDNotificationHeaderCell
        return cell?.contentView ?? UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
