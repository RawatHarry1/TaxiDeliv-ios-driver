//
//  VDWalletVC.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VDWalletVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    
    var viewModel: VDWalletViewModel = VDWalletViewModel()
    var myTransaction: [Transactions]?
    var fromNotificationClick: Bool = false
    var amount = ""
    var ohjGetCardData : GetCardData?
    //  To create ViewModel
    static func create() -> VDWalletVC {
        let obj = VDWalletVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {

        if fromNotificationClick {
            backBtn.setImage(VDImageAsset.backbutton.asset, for: .normal)
        }

        walletTableView.delegate = self
        walletTableView.dataSource = self
        walletTableView.register(UINib(nibName: "VDWalletCell", bundle: nil), forCellReuseIdentifier: "VDWalletCell")
        walletTableView.register(UINib(nibName: "VDWalletHeaderCell", bundle: nil), forCellReuseIdentifier: "VDWalletHeaderCell")

        let dispatchGroup = DispatchGroup()
        ///`Call Enter Function`
        dispatchGroup.enter()
//        viewModel.fetchWalletBalance()
        dispatchGroup.leave()

        ///`Call Enter Function`
        dispatchGroup.enter()
        viewModel.fetchwalletTransactions()
        dispatchGroup.leave()

//        viewModel.updateWalletDetails = { (walletDetails) in
//            if let balance = walletDetails.venus_balance {
//                if let currency = UserModel.currentUser.login?.currency_symbol {
//                    self.balanceLbl.text = currency + " " + (balance.toString ?? "0.00")
//                } else  {
//                    self.balanceLbl.text = "$ " + (balance.toString ?? "0.00")
//                }
//                self.nameLbl.text = walletDetails.user_name ?? ""
//            } else {
//
//            }
//        }

        viewModel.updateWalletTransactions = { [weak self] walletDetails in
            if let balance = walletDetails.balance {
                if let currency = UserModel.currentUser.login?.currency_symbol {
                    let walletBalance = balance.toString
                    self?.balanceLbl.text = currency + " " + walletBalance
                } else  {
                    self?.balanceLbl.text = "$ " + (balance.toString )
                }
                self?.nameLbl.text = walletDetails.user_name ?? ""
            } else {
                
            }
            self?.myTransaction = walletDetails.transactions
            self?.walletTableView.reloadData()
            
            guard let model = UserModel.currentUser.login else {return}
            guard let minBalance = model.min_driver_balance else {return}
            guard let actualBalance = model.actual_credit_balance else {return}
            
            if actualBalance < minBalance {
                self?.balanceLbl.textColor = VDColors.textColorRed.color
                self?.infoLbl.isHidden = false
            } else {
                self?.balanceLbl.textColor = VDColors.textColorWhite.color
                self?.infoLbl.isHidden = true
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWalletScreen(notification:)), name: .updateWalletBalance, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidAppear(_ animated: Bool) {
        if let currentVc = sharedAppDelegate.window?.currentViewController as? VDLGMainVC {
            if let sideMenu = (currentVc as? VDLGMainVC)?.rootViewController as? VDWalletVC {
                printDebug(sideMenu)
            }
        }
    }

    @objc func refreshWalletScreen( notification: Notification) {
        let dispatchGroup = DispatchGroup()
        ///`Call Enter Function`
        dispatchGroup.enter()
        viewModel.fetchWalletBalance()
        dispatchGroup.leave()

        ///`Call Enter Function`
        dispatchGroup.enter()
        viewModel.fetchwalletTransactions()
        dispatchGroup.leave()
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if fromNotificationClick {
            VDRouter.goToSaveUserVC()
        } else {
            guard let sideMenuController = sideMenuController else { return }
            sideMenuController.showLeftView()
        }
    }

    @IBAction func btnTopUp(_ sender: UIButton) {
        let vc = VDTopUPPopVC.create()
        vc.modalPresentationStyle = .overFullScreen
        vc.parseAmountToAdd = { amount in
            self.amount = amount
            let vc = CardsVC.create()
            vc.sideMenuHide = true
            vc.comesFromAccount = false
            vc.modalPresentationStyle = .overFullScreen
            
            vc.didPressSelecrCard = { selectedCardData in
                self.ohjGetCardData = selectedCardData
                self.addMoneyAlert(cardNo: selectedCardData.last_4 ?? "")
            }
            self.present(vc, animated: true)
            //self.navigationController?.pushViewController(CardsVC.create(), animated: true)
        }
        self.present(vc, animated: true)
       // self.navigationController?.present(vc, animated: true)
    }
    
    func addMoneyAlert(cardNo:String){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to use **** \(cardNo) card for top up?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.viewModel.addAmountApi(cardID: self.ohjGetCardData?.card_id ?? "", amount: self.amount,currency:UserModel.currentUser.login?.currency_symbol ?? "") {
                self.initialSetup()
            }
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

extension VDWalletVC: UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noDataLbl.isHidden = false
        guard let transactions = myTransaction else {
            return 0 }
        (transactions.count > 0) ? (self.noDataLbl.isHidden = true) : (self.noDataLbl.isHidden = false)
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDWalletCell", for: indexPath) as! VDWalletCell
        if let transactions = myTransaction {
            cell.setUpUI(transactions[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDWalletHeaderCell") as! VDWalletHeaderCell
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
