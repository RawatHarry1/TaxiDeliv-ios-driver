//
//  VCFAQVC.swift
//  VenusCustomer
//
//  Created by Amit on 07/07/23.
//

import UIKit

class VDFAQVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var faqTableView: UITableView!

    // MARK: -> Variables
    var indexSelection = -1

    //  To create ViewModel
    static func create() -> VDFAQVC {
        let obj = VDFAQVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.register(UINib(nibName: "VDFAQCell", bundle: nil), forCellReuseIdentifier: "VDFAQCell")
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func selectionAction(_ button: UIButton) {
        indexSelection == button.tag ? (indexSelection = -1) : (indexSelection = button.tag)
        faqTableView.reloadData()
    }
}

extension VDFAQVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDFAQCell", for: indexPath) as! VDFAQCell
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.addTarget(self, action: #selector(selectionAction(_ :)), for: .touchUpInside)
        cell.setUpUI(indexSelection != indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
