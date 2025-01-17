//
//  VDRideCompleteVC.swift
//  VenusDriver
//
//  Created by Amit on 20/06/23.
//

import UIKit
import CoreLocation
import SDWebImage
class VDRideCompleteVC: VDBaseVC {
    var objDelivery_packages = [DeliveryPackageData]()
    @IBOutlet weak var packageTblHeader: UIView!
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var tblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var dashLineView: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgCall: UIImageView!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var rideDetailsView: UIView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pickUpLbl: UILabel!
    @IBOutlet weak var dropLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var customerImg: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    var screenTyoe = 0 // 0 completed , 1 accept ride , 2 ride accepted

    var viewModel = VDHomeViewModel()
    var tripID: String?
    var markArrived:((Int) -> Void)?
    var endRideModel : EndRideModel?
    var phoneNo = ""
    var profileImg = ""
    var customerID = ""
    var profileName = ""
    //  To create ViewModel
    static func create(_ type: Int = 0) -> VDRideCompleteVC {
        let obj = VDRideCompleteVC.instantiate(fromAppStoryboard: .postLogin)
        obj.screenTyoe = type
        return obj
    }
    @IBOutlet weak var chatIcon: UIImageView!
    
    var currentLat = 0.0
    var currentLong = 0.0
    
    override func getCurrentLocation(lat: CLLocationDegrees, long: CLLocationDegrees) {
        currentLat = lat
        currentLong = long
    }

    override func initialSetup() {
        self.btnChat.isHidden = true
        viewDot.isHidden = true
        self.btnCancel.isHidden = true
        if screenTyoe == 2 {
            self.btnBack.isHidden = true
            btnAccept.isHidden = false
            titleLabel.text = "Trip Accepted"
            btnAccept.setTitle("Go to Pick-Up", for: .normal)
            self.btnCancel.isHidden = false
        }
        btnAccept.isHidden = (screenTyoe == 0)
        titleLabel.text = (screenTyoe == 0) ? "Ride Completed" : "Accept Trip"
        imgCall.isHidden = (screenTyoe == 0)
        chatIcon.isHidden = (screenTyoe == 0)
        rideDetailsView.isHidden = (screenTyoe == 0)
        
        if titleLabel.text! == "Accept Trip"
        {
            btnChat.isHidden = true
            viewDot.isHidden = true
            chatIcon.isHidden = true
        }
        if screenTyoe == 0 {
            btnAccept.isHidden = false
            self.btnAccept.setTitle("Rate Customer", for: .normal)
            updateEndRidePopUp()
        } else {
            //btnAccept.isHidden = true
            self.btnAccept.setTitle("Accept", for: .normal)
            updateAvailableRidePopUp()
        }

        viewModel.rideDetailsCallBack = { rideDetails in
            self.tripID = self.viewModel.rideDetails.tripId ?? ""
            self.btnChat.isHidden = false
            self.screenTyoe = 2
            self.btnBack.isHidden = true
            self.btnAccept.isHidden = false
            self.titleLabel.text = "Trip Accepted"
            self.btnAccept.setTitle("Go to Pick-Up", for: .normal)
            self.btnCancel.isHidden = false
        }

        viewModel.tripStartedSuccessCallBack = { status in
            RideStatus = .customerPickedUp
            self.dismiss(animated: true)
        }

        viewModel.markArrivedSuccessCallBack = { status in
            RideStatus = .customerPickedUp
            self.markArrived?(1)
            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true) {
//            }
        }
        
        viewModel.rideCancelledSuccessCallBack = { cancelModel in
            if cancelModel.driver_blocked_multiple_cancelation?.blocked == 1 {
                var userModel = UserModel.currentUser
                userModel.login?.driver_blocked_multiple_cancelation?.blocked = 1
                UserModel.currentUser = userModel
            } else {
                SKToast.show(withMessage: "Ride has been cancelled by you.")
            }
            
            sharedAppDelegate.isFromNotification = false
            sharedAppDelegate.notficationDetails = nil
            RideStatus = .none
            VDRouter.goToSaveUserVC()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(clearOngoingNotification(notification:)), name: .clearNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.messageReceiver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageNotify(notification:)), name: .newMessage, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.objDelivery_packages.isEmpty == true
        {
            self.tblView.isHidden = true
            self.packageTblHeader.isHidden = true
            self.lblSeperator.isHidden = true
            self.viewSpace.isHidden = false
        }
    }
    
    @objc func newMessageNotify(notification: Notification) {
        viewDot.isHidden = true
        //if self.navigationController != nil{
//        if navigateToChat == true{
//            navigateToChat = false
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
//            vc.tripID = self.tripID ?? ""
//            vc.customer_id = self.customerID
//            vc.profileImg = self.profileImg
//            vc.name = self.profileName
//           
//                
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
           
           
      //  }
        
    }


    override func viewDidLayoutSubviews() {
        drawDashedLine()
    }

    @objc func clearOngoingNotification(notification: Notification) {
        VDRouter.goToSaveUserVC()
    }
    
    @objc func handleNotification(_ notification: Notification) {
        self.viewDot.isHidden = false

    }

    func drawDashedLine() {
        dashedView.addDashedSmallBorder()
    }

    @IBAction func btnchatAction(_ sender: Any) {
        viewDot.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
        vc.tripID = self.tripID ?? ""
        vc.customer_id = self.customerID
        vc.profileImg = self.profileImg
        vc.name = self.profileName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateAvailableRidePopUp() {
        if let notificationModel = sharedAppDelegate.notficationDetails {
            if (notificationModel.status == notificationTypes.new_ride_request.rawValue) || (notificationModel.status == rideStatus.acceptedRide.rawValue) {
                if let urlStr = notificationModel.customer_image {
                    self.customerImg.sd_setImage(with: URL(string: urlStr), placeholderImage: VDImageAsset.imgPlaceholder.asset, options: [.refreshCached, .highPriority], completed: nil)
//                    self.customerImg.setImage(withUrl: urlStr) { status, image in
//                        if status {
//                            if let img = image {
//                                self.customerImg.image = img
//                            }
//                        }
//                    }
                } else {
                    self.customerImg.image = VDImageAsset.imgPlaceholder.asset
                }
                
                if notificationModel.customer_notes ?? "" == ""{
                    self.lblNotes.isHidden = true
                }else{
                    self.lblNotes.isHidden = false
                    self.lblNotes.text = "Note: \(notificationModel.customer_notes ?? "")"
                }
               
                self.customerNameLbl.text = notificationModel.customer_name ?? ""
                
                if let estimatedFare = notificationModel.estimated_driver_fare,
                   let currency = notificationModel.currency,
                   estimatedFare.contains(currency) {
                    // Do something when estimated fare contains the currency
                    self.fareLbl.text = "\(notificationModel.estimated_driver_fare ?? "")"
                } else {
                    // Do something else if it doesn't contain the currency
                    self.fareLbl.text = "\(UserModel.currentUser.login?.currency_symbol ?? "")\(notificationModel.estimated_driver_fare ?? "")"
                }
                
                //self.fareLbl.text = "\(UserModel.currentUser.login?.currency_symbol ?? "")\(notificationModel.estimated_driver_fare ?? "")"
                if let formattedDate = notificationModel.date {
                    self.timeLbl.text = ConvertDateFormater(date: formattedDate)
                }
                self.pickUpLbl.text = notificationModel.pickup_address ?? ""
                self.dropLbl.text = notificationModel.drop_address ?? ""
                self.phoneNo = notificationModel.user_phone_no ?? ""
                
                self.profileImg = notificationModel.customer_image ?? ""
                self.customerID = notificationModel.customer_id ?? ""
                self.profileName = notificationModel.customer_name ?? ""
            }
        }
    }

    func updateEndRidePopUp() {
        if let endRide = self.endRideModel {
            if let currency = UserModel.currentUser.login?.currency_symbol {
                self.fareLbl.text = currency + " " +  (endRide.to_pay?.toString ?? "")
            } else {
                self.fareLbl.text = (endRide.currency ?? "") + " " +  (endRide.to_pay?.toString ?? "")
            }
            if let myDate = endRide.driver_ride_date {
                self.timeLbl.text = ConvertDateFormater(date: myDate)
            } else {
//                self.timeLbl.text = endRide.driver_ride_date ?? ""
            }
            if let urlStr = endRide.customer_image {
                self.customerImg.sd_setImage(with: URL(string: urlStr), placeholderImage: VDImageAsset.imgPlaceholder.asset, options: [.refreshCached, .highPriority], completed: nil)
            } else {
                self.customerImg.image = VDImageAsset.imgPlaceholder.asset
            }
            self.customerNameLbl.text = endRide.customer_name
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if screenTyoe == 0 {
            VDRouter.goToSaveUserVC()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnCallAction(_ sender: Any) {
        guard let url = URL(string: "telprompt://\(phoneNo)"),
               UIApplication.shared.canOpenURL(url) else {
               return
           }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    

    @IBAction func btnAccept(_ sender: UIButton) {
        if screenTyoe == 1 {
            if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
                var att = [String:Any]()
                att["tripId"] = tripID
                att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""
                att["longitude"] = self.currentLong
                att["latitude"] = self.currentLat
                
              
                viewModel.acceptRideApi(att, completionFaliur: { str in
                    self.faliurAlert(strg: str)
                })
            }
        } else if screenTyoe == 2 {
           
            self.navigationController?.popViewController(animated: true)
        }else{
            let story = UIStoryboard(name: "Ratings", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "VCFeedbackVC") as! VCFeedbackVC
            vc.objEndTripModal = endRideModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        self.dismiss(animated: true)
    }
    
    func faliurAlert(strg: String){
        let refreshAlert = UIAlertController(title: "", message: strg, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            RideStatus = .none
          print("Handle Ok logic here")
            self.navigationController?.popViewController(animated: true)
           
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelRideBtn(_ sender: UIButton) {
        let vc = VDCancelRideVC.create()
        vc.onConfirm = { status in
            if status == 1 {
                let vc = VDCancelReasonVC.create()
                vc.selectedReason = { [weak self] reason in
                    print(reason)
                    guard let tripID = sharedAppDelegate.notficationDetails?.trip_id else {return}
                    guard let customerID = sharedAppDelegate.notficationDetails?.customer_id else {return}
                    self?.viewModel.cancelRideApi(tripID, customerID, reason)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
}


extension UIView {
        func addDashedBorder() {
            //Create a CAShapeLayer
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = self.bounds
            shapeLayer.strokeColor = VDColors.textColor.color.cgColor
            shapeLayer.lineWidth = 2
            // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
            shapeLayer.lineDashPattern = [6,7]

            let size = shapeLayer.frame.size
            let rightTop = CGPoint.zero
            let leftTop = CGPoint(x: size.width, y: 0)
            let leftBottom = CGPoint(x: size.width, y: size.height)
            let rightBottom = CGPoint(x: 0, y: size.height)

            let path = CGMutablePath()
            path.addLines(between: [rightTop, leftTop])
            shapeLayer.path = path
            layer.addSublayer(shapeLayer)
        }

    func addDashedSmallBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.strokeColor = VDColors.textColor.color.cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]

        let size = shapeLayer.frame.size
        let rightTop = CGPoint.zero
        let leftTop = CGPoint(x: size.width, y: 0)
        let leftBottom = CGPoint(x: size.width, y: size.height)
        let rightBottom = CGPoint(x: 0, y: size.height)

        let path = CGMutablePath()
        path.addLines(between: [rightTop, rightBottom])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
extension VDRideCompleteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objDelivery_packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailTblCell", for: indexPath) as! PackageDetailTblCell
        let obj = self.objDelivery_packages[indexPath.row]
        cell.lblSize.text = obj.package_size ?? ""
        cell.lblPackageType.text = obj.type ?? ""
        cell.lblQuantity.text = obj.quantity ?? ""
        cell.objDelivery_packages = obj
        cell.collectionViewImages.reloadData()
        cell.collectionViewImages.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tblHeightConstant.constant = self.tblView.contentSize.height
            self.tblView.isHidden = self.tblView.numberOfRows(inSection: 0) == 0 ? true : false
            self.packageTblHeader.isHidden = self.tblView.numberOfRows(inSection: 0) == 0 ? true : false
        }
    }
}

extension VDRideCompleteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(58, 58)
    }
    
    
    
}
