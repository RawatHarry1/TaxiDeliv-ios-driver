//
//  VDPaymentListVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VDPaymentListVC: VDBaseVC {

    @IBOutlet weak var paymentTableView: UITableView!

    //  To create ViewModel
    static func create() -> VDPaymentListVC {
        let obj = VDPaymentListVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(UINib(nibName: "VDCardDetailCell", bundle: nil), forCellReuseIdentifier: "VDCardDetailCell")

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension VDPaymentListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDCardDetailCell", for: indexPath) as! VDCardDetailCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
