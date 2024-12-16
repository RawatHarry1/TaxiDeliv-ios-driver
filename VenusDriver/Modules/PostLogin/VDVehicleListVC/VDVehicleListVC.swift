//
//  VDVehicleListVC.swift
//  VenusDriver
//
//  Created by Amit on 21/06/23.
//

import UIKit

class VDVehicleListVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var vehicleTableView: UITableView!

    private var vehicles : [VehiclesList]?

    //  To create ViewModel
    static func create(_ vehicles : [VehiclesList]) -> UIViewController {
        let obj = VDVehicleListVC.instantiate(fromAppStoryboard: .postLogin)
        obj.vehicles = vehicles
        return obj
    }

    override func initialSetup() {
        vehicleTableView.delegate = self
        vehicleTableView.dataSource = self
        vehicleTableView.register(UINib(nibName: "VDVehicleCell", bundle: nil), forCellReuseIdentifier: "VDVehicleCell")
    }

    @IBAction func btnAddDoc(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDElectricVC.create(1), animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        guard let sideMenu = sideMenuController else { return }
        sideMenu.showLeftView()
    }
}

extension VDVehicleListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDVehicleCell", for: indexPath) as? VDVehicleCell
        cell?.updateUI(vehicles![indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
