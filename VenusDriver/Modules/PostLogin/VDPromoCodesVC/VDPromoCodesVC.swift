//
//  VCPromoCodesVC.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VDPromoCodesVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var promoTableView: UITableView!

    //  To create ViewModel
    static func create() -> VDPromoCodesVC {
        let obj = VDPromoCodesVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        promoTableView.delegate = self
        promoTableView.dataSource = self
        promoTableView.register(UINib(nibName: "VDPromoCell", bundle: nil), forCellReuseIdentifier: "VDPromoCell")
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VDPromoCodesVC : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDPromoCell", for: indexPath) as! VDPromoCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
