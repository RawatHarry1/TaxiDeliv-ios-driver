//
//  VDSideMenuVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDSideMenuVC: VDBaseVC {

    // MARK: - Outlets
    @IBOutlet weak private(set) var menuTableView: UITableView!

    private var viewModel = VDSideMenuViewModel()

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDSideMenuVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        menuTableView.register(UINib(nibName: "VDSideMenuCell", bundle: nil), forCellReuseIdentifier: "VDSideMenuCell")
        menuTableView.dataSource = self
        menuTableView.delegate = self

        viewModel.vehicleListCallBack = { vehicles in
            guard let sideMenuController = self.sideMenuController else { return }
            sideMenuController.hideLeftView()
            sideMenuController.rootViewController = VDVehicleListVC.create(vehicles)
        }

        viewModel.informationUrlsCallback = { urls in
            self.sideMenuController?.rootViewController = VDAboutAppVC.create(urls)
        }
    }
//    override func viewDidLoad() {
//        self.navigationController?.navigationBar.isHidden = true
//    }
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    func reloadData() {
        self.menuTableView.reloadData()
    }
    
    func deleteAccount(){
        deleteAccountAlert()
       
    }
    
    func deleteAccountAlert(){
        let refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete the Account?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.viewModel.deleteAccount([:], completion: {
                RideStatus = .none
                VDUserDefaults.removeAllValues()
                VDRouter.loadPreloginScreen()
                UserDefaults.standard.set("false", forKey: "isLogin")
            })
           
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }


    @IBAction func btnSupport(_ sender: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.hideLeftView()
        sideMenuController.rootViewController = VDSupportVC.create()
    }
}

extension VDSideMenuVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDSideMenuCell", for: indexPath) as? VDSideMenuCell
        cell?.setUpUI(indexPath.row)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7{
            return 0
        }
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.hideLeftView()
        switch indexPath.row {
        case 0:
            sideMenuController.rootViewController = UINavigationController(rootViewController: VDHomeVC.create())
        case 1:
           
          sideMenuController.rootViewController = VDAccountVC.create()
          
        case 2:
            sideMenuController.rootViewController = VDEarningVC.create(0)
        case 3:
            sideMenuController.rootViewController = VDWalletVC.create()
            
        case 4:
           // print("cards")
            sideMenuController.rootViewController = CardsVC.create()
        case 5:
            sideMenuController.rootViewController = VDEarningVC.create(1)
        case 6:
            sideMenuController.rootViewController = VDDocumentVC.create()
        case 7:
            sideMenuController.rootViewController = VDRatingsVC.create()
        case 8:
            sideMenuController.rootViewController = VDNotificationVC.create()
        case 9:
            viewModel.fetchUrlInformation()
        case 10:
            viewModel.fetchDriverDocuments()
//            let isDriverAvailable = VDUserDefaults.value(forKey: .isDriverAvailable)
//            if let value = isDriverAvailable.rawValue as? Bool {
//                if value {
//                    if let _ = UserModel.currentUser.login?.make_details {
//                        sideMenuController.rootViewController = VDVehicleListVC.create()
//                    } else {
//                        SKToast.show(withMessage: "Not able to fetch vehicle details.")
//                    }
//                } else {
//                    SKToast.show(withMessage: "Your documents are not approved from admin.")
//                }
//            } else {
//
//            }
            
        case 11:
            print("tickets")
            sideMenuController.rootViewController = TicketListVC.create()
        case 12:
            print("Delete Account")
            self.deleteAccount()
            
        case 13:
            let story = UIStoryboard(name: "PostLogin", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "VDLogoutVC") as! VDLogoutVC//VDLogoutVC.create()
            vc.modalPresentationStyle = .overFullScreen
            vc.cancelCallBack = { cancel in
                if cancel {

                }
            }
            self.present(vc, animated: true)
        default:
            break
        }
    }
}
