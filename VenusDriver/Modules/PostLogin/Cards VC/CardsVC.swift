//
//  CardsVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/08/24.
//

import UIKit

import StripePaymentSheet
class CardsVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnAddNewCard: VDButton!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tblViewCards: UITableView!
    @IBOutlet weak var viewStack: UIStackView!
    
   // var paymentSheet: PaymentSheet?
    var paymentSheet: PaymentSheet?
    var objCardsVM = CardsVM()
    var clientSecret = ""
    var setUpIntentID = ""
    var selectedIndex = -1
    var emptyObj : GetCardData?
    var didPressSelecrCard: ((GetCardData)->Void)?
    var comesFromAccount = true
   var sideMenuHide = false
    
    static func create() -> CardsVC {
        let obj = CardsVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stripSheet()
        tblViewCards.register(UINib(nibName: "CardsTblCell", bundle: nil), forCellReuseIdentifier: "CardsTblCell")
        getCardApi()
        tblViewCards.rowHeight = 60
        self.viewStack.layer.cornerRadius = 6
        self.viewStack.addShadowView(width : 0, height : 0,opacidade : 0.3, radius:2)

        if sideMenuHide == true{
            btnBack.setImage(UIImage(named: "backbutton"), for: .normal)
        }else{
            btnBack.setImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
    
    func getCardApi(){
        objCardsVM.getCardApi {
            self.tblViewCards.reloadData()
        }
    }
    
    func addCardsApi(){
        self.objCardsVM.addCard(clientSecret: UserModel.currentUser.login?.stripeCredentials?.client_secret ?? "") {
            self.clientSecret = self.objCardsVM.objCardModal?.data?.client_secret ?? ""
            self.setUpIntentID = self.objCardsVM.objCardModal?.data?.setupIntent?.id ?? ""
            var configuration = PaymentSheet.Configuration()
            configuration.allowsDelayedPaymentMethods = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.clientSecret, configuration: configuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.configurePaymentSheet()
            }
        }
    }
    
    func deleteCardApi(cardID:String){
        objCardsVM.deleteCard(cardID: cardID) {
            self.getCardApi()
        }
    }
    
    func confirmCardApi(){
        
        self.objCardsVM.confirmCard(clientSecret: UserModel.currentUser.login?.stripeCredentials?.client_secret ?? "", id: self.setUpIntentID) {
            self.getCardApi()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if sideMenuHide == true{
            self.dismiss(animated: true)
        }else{
            guard let sideMenu = sideMenuController else { return }
            sideMenu.showLeftView()
        }
       
    }
    
    func configurePaymentSheet() {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Your Merchant Name"
        configuration.allowsDelayedPaymentMethods = true
        
        // Initialize the PaymentSheet
        self.paymentSheet = PaymentSheet(setupIntentClientSecret: self.clientSecret, configuration: configuration)
        DispatchQueue.main.async {
            self.presentPaymentSheet()
        }
    }
    
    func presentPaymentSheet() {
        self.paymentSheet?.present(from: self) { paymentResult in
            // Handle the payment result
            switch paymentResult {
            case .completed:
                print("Your order is confirmed")
                self.confirmCardApi()
            case .canceled:
                print("Canceled!")
            case .failed(let error):
                print("Payment failed: \(error)")
            }
        }
    }
    
    @IBAction func btnAddNewCardAction(_ sender: Any) {
        addCardsApi()
    }
    
    func stripSheet(){
        print(UserModel.currentUser.login?.stripeCredentials?.publishable_key ?? "")
        STPAPIClient.shared.publishableKey = UserModel.currentUser.login?.stripeCredentials?.publishable_key ?? ""
    }
    
    func deleteCardAlert(id:String){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the  card?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.deleteCardApi(cardID: id)
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

extension CardsVC: UITableViewDelegate,UITableViewDataSource{
    @objc func cardDelete(_ sender : UIButton )
    {
        let obj = self.objCardsVM.objGetCardModal?.data?[sender.tag]
        self.deleteCardAlert(id: obj?.card_id ?? "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objCardsVM.objGetCardModal?.data?.count ?? 0 > 0{
            lblNoDataFound.isHidden = true
        }else{
            lblNoDataFound.isHidden = false
        }
        return self.objCardsVM.objGetCardModal?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardsTblCell", for: indexPath) as! CardsTblCell
        let obj = self.objCardsVM.objGetCardModal?.data?[indexPath.row]
        cell.lblCardNumber.text = "**** **** **** \(obj?.last_4 ?? "")"
        cell.lblCardType.text = obj?.brand
        cell.imgDelete.isHidden = false
        cell.btnDelete.isHidden = false
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(cardDelete), for: .touchUpInside)
        
        if comesFromAccount == true{
            cell.imgViewRadio.isHidden = true
            cell.imgDelete.isHidden = false
            cell.btnDelete.isHidden = false
        }else{
            cell.imgViewRadio.isHidden = false
            cell.imgDelete.isHidden = true
            cell.btnDelete.isHidden = true

        }
        
        if emptyObj?.id == obj?.id{
            cell.imgViewRadio.image = UIImage(named: "radioSelected")
        }else{
            cell.imgViewRadio.image = UIImage(named: "radio")
        }
        
        if emptyObj?.id == nil{
            if selectedIndex == indexPath.row{
                cell.imgViewRadio.image = UIImage(named: "radioSelected")
                if comesFromAccount == false{
                    self.dismiss(animated: true) {
                        self.didPressSelecrCard!(obj!)
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                   
                }
            }else{
              
                cell.imgViewRadio.image = UIImage(named: "radio")
            }
        }
     
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let obj = self.objCardsVM.objGetCardModal?.data?[indexPath.row]
//           // Create a delete action
//           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//               // Handle the delete action
//               self.deleteCardAlert(id: obj?.card_id ?? "")
//              
//               handler(true)
//           }
//           
//           // Create a configuration with the delete action
//           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//           configuration.performsFirstActionWithFullSwipe = true // Optional: Enable full swipe to trigger the action
//           
//           return configuration
//       
//   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comesFromAccount == false{
            emptyObj = nil
            selectedIndex = indexPath.row
            self.tblViewCards.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tblHeightConstant.constant = CGFloat(60 * self.tblViewCards.numberOfRows(inSection: 0)) + 10
        }
    }
}
