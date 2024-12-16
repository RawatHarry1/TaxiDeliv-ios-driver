//
//  VDRatingsVC.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

class VDRatingsVC: VDBaseVC {
    // MARK: -> Outlets
    @IBOutlet weak var ratingTableView: UITableView!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDRatingsVC.instantiate(fromAppStoryboard: .ratings)
        return obj
    }

    override func initialSetup() {
        ratingTableView.delegate = self
        ratingTableView.dataSource = self

        ratingTableView.register(UINib(nibName: "VDRatingsTableCell", bundle: nil), forCellReuseIdentifier: "VDRatingsTableCell")
    }

    @IBAction func btnSideMenu(_ sender: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.showLeftView()
    }
}

extension VDRatingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDRatingsTableCell", for: indexPath) as? VDRatingsTableCell
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
