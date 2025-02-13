//
//  PackageListVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/11/24.
//

import UIKit

class PackageListVC: UIViewController, CollectionViewCellDelegate {
    
    @IBOutlet weak var btnContinue: VDButton!
    @IBOutlet weak var tblView: UITableView!
    var viewModel = VDHomeViewModel()
    var driver_package_images = false
    var deliveryPackages : [DeliveryPackages]?
    var viewModal = UploadPhotoViewModal()
    var didPressContinue: (() -> Void)?
    var comesFromMardArrive = false
    var deliveryImages = [String]()
    var imgArr = [String]()
    var can_start = false
    var can_end = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.alpha = 0.4
        btnContinue.isEnabled = false
        if comesFromMardArrive == true
        {
            if can_start == true
            {
                btnContinue.alpha = 1
                btnContinue.isEnabled = true

            }
        }
        else
        {
            if can_end == true
            {
                btnContinue.alpha = 1
                btnContinue.isEnabled = true

            }
        }
//        btnContinue.alpha = !driver_package_images == true ? 1 : 0.4
//        btnContinue.isEnabled = !driver_package_images
//        if driver_package_images == true
//        {
//            btnContinue.isEnabled = true
//            btnContinue.alpha = 1
//        }
        if RideStatus == .markArrived {
            
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        self.didPressContinue!()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func displayCancelAlert(_ message: String,title:String,reason : String) {
        let story = UIStoryboard(name: "PostLogin", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "VDLogoutVC") as! VDLogoutVC
        vc.descriptionText = message
        vc.rejectPackage = true
        vc.modalPresentationStyle = .overFullScreen
        vc.cancelCallBack = { cancel in
            if cancel {
                
            }
            
        }
        vc.sucessCallback = { sucess in
            if sucess {
                guard let tripID = sharedAppDelegate.notficationDetails?.trip_id else {return}
                guard let customerID = sharedAppDelegate.notficationDetails?.customer_id else {return}
                self.viewModel.cancelRideApi(tripID, customerID, reason)
                //  SKToast.show(withMessage: "Ride has been Cancelled by you.")
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        self.present(vc, animated: true)
        //        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        //        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
        //            guard let tripID = sharedAppDelegate.notficationDetails?.trip_id else {return}
        //            guard let customerID = sharedAppDelegate.notficationDetails?.customer_id else {return}
        //            self.viewModel.cancelRideApi(tripID, customerID, reason)
        
        //
        //        })
        //        alert.addAction(action)
        //       // UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        //        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension PackageListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryPackages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageListTblCell", for: indexPath) as! PackageListTblCell
        cell.lblSize.text = deliveryPackages?[indexPath.row].package_size ?? ""
        cell.lblPackageType.text = deliveryPackages?[indexPath.row].package_type ?? ""
        cell.lblQuantity.text = "\(deliveryPackages?[indexPath.row].package_quantity ?? 0)"
        cell.deliveryPackages = self.deliveryPackages?[indexPath.row]
        cell.delegate = self
        if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
            cell.lblStatus.text = "Not Picked"
            cell.lblStatus.textColor = .systemRed
            cell.viewStatus.isHidden = true
            cell.btnAccept.isEnabled = false
            cell.btnreject.isEnabled = false
            cell.btnAccept.alpha = 0.4
            cell.btnreject.alpha = 0.4
            cell.imagesStackView.isHidden = true
            cell.deliveryStackView.isHidden = true
        }else{
            cell.viewStatus.isHidden = true
            cell.btnAccept.isEnabled = true
            cell.btnreject.isEnabled = true
            cell.btnAccept.alpha = 1
            cell.btnreject.alpha = 1
            cell.imagesStackView.isHidden = false
            cell.deliveryStackView.isHidden = false
        }
//        cell.imagesArr = self.deliveryPackages?[indexPath.row].package_image_while_pickup
//        cell.deliveryImagesArr = self.deliveryPackages?[indexPath.row].package_image_while_drop_off

        if comesFromMardArrive == true{
            
            if self.deliveryPackages?[indexPath.row].package_image_while_pickup?.count ?? 0 > 0
            {
                cell.btnAccept.isEnabled = false
                cell.btnreject.isEnabled = false
                cell.btnAccept.alpha = 0.4
                cell.btnreject.alpha = 0.4
//                cell.imagesArr = self.deliveryPackages?[indexPath.row].package_image_while_pickup
                cell.collectionViewImages.reloadData()
                cell.imagesStackView.isHidden = false
//                self.btnContinue.alpha = 1
//                self.btnContinue.isEnabled = true
            }
            else
            {
                if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5 {
                    
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
                    
                }
                else{
                 
//                    if self.imgArr.count  > 0{
//                        cell.btnAccept.isEnabled = false
//                        cell.btnreject.isEnabled = false
//                        cell.btnAccept.alpha = 0.4
//                        cell.btnreject.alpha = 0.4
//                        cell.imagesArr = self.imgArr
//                        cell.collectionViewImages.reloadData()
//                        cell.imagesStackView.isHidden = false
//                    }
                    
//                    else{
                        if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 1
                        {
                            cell.btnAccept.isEnabled = false
                            cell.btnreject.isEnabled = false
                            cell.btnAccept.alpha = 0.4
                            cell.btnreject.alpha = 0.4

                        }
                        else
                        {
                            cell.btnAccept.isEnabled = true
                            cell.btnreject.isEnabled = true
                            cell.btnAccept.alpha = 1
                            cell.btnreject.alpha = 1

                        }
                     
                        cell.imagesStackView.isHidden = true
                  //  }
//                     if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 1
//                     {
//                         cell.btnAccept.isEnabled = false
//                         cell.btnreject.isEnabled = false
//                         cell.btnAccept.alpha = 0.4
//                         cell.btnreject.alpha = 0.4
// //                        self.btnContinue.alpha = 1
// //                        self.btnContinue.isEnabled = true
//
//                     }
                    
                }
            }
            
            cell.deliveryStackView.isHidden = true
            cell.btnAccept.setTitle("ACCEPT", for: .normal)
            cell.btnreject.setTitle("REJECT", for: .normal)
        }else{
            cell.collectionViewImages.reloadData()
            if self.deliveryPackages?[indexPath.row].package_image_while_pickup?.count ?? 0 > 0
            {
                cell.lblTopDelivery.isHidden = false

            }
            else
            {
                cell.lblTopDelivery.isHidden = true

            }
            if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
                cell.lblStatus.text = "Not Picked"
                cell.lblStatus.textColor = .systemRed
                cell.viewStatus.isHidden = false
                cell.mainStack.isHidden = false
                cell.imagesStackView.isHidden = true
                cell.deliveryStackView.isHidden = true
            }else{
                if self.deliveryPackages?[indexPath.row].package_image_while_drop_off?.count ?? 0 > 0
                {
                    cell.viewStatus.isHidden = true
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
//                    cell.deliveryImagesArr = self.deliveryPackages?[indexPath.row].package_image_while_drop_off
                    cell.collectionVwDropOffImgs.reloadData()
                    cell.deliveryStackView.isHidden = false
//                    self.btnContinue.alpha = 1
//                    self.btnContinue.isEnabled = true
                    
                }
                else
                {
                    if self.deliveryImages.count > 0{
                        cell.btnAccept.isEnabled = false
                        cell.btnreject.isEnabled = false
                        cell.btnAccept.alpha = 0.4
                        cell.btnreject.alpha = 0.4
                 //       cell.deliveryImagesArr = self.deliveryImages
                        cell.collectionVwDropOffImgs.reloadData()
                        cell.deliveryStackView.isHidden = false
                    }else{
                        if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 4
                        {
                            cell.btnAccept.isEnabled = false
                            cell.btnreject.isEnabled = false
                            cell.btnAccept.alpha = 0.4
                            cell.btnreject.alpha = 0.4

                        }
                        else
                        {
                            cell.btnAccept.isEnabled = true
                            cell.btnreject.isEnabled = true
                            cell.btnAccept.alpha = 1
                            cell.btnreject.alpha = 1

                        }
                        
                    
                        cell.deliveryStackView.isHidden = true
                        
                    }
                }
                cell.imagesStackView.isHidden = self.deliveryPackages?[indexPath.row].package_image_while_pickup?.count ?? 0 > 0 ? false : true
                 
                
                cell.mainStack.isHidden = false
                if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 4
                {
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
//                    self.btnContinue.alpha = 1
//                    self.btnContinue.isEnabled = true

                }
            }
            cell.btnAccept.setTitle("DELIVERED", for: .normal)
            cell.btnreject.setTitle("NOT DELIVERED", for: .normal)
        }
        
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(didPressAccept), for: .touchUpInside)
//        cell.didPressAccept = {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadPackageVC") as! UploadPackageVC
//            vc.driver_package_images = self.driver_package_images
//            vc.modalPresentationStyle = .overFullScreen
//            vc.acceptTripCallBack = { imageArr in
//                print(imageArr)
//                if imageArr.count != 0{
//
//                    self.imgArr = imageArr
//                    self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
//
//                        if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
//                            Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
//                        }
//
//                        cell.btnAccept.isEnabled = false
//                        cell.btnreject.isEnabled = false
//                        cell.btnAccept.alpha = 0.4
//                        cell.btnreject.alpha = 0.4
//
//                        if self.comesFromMardArrive == true{
//                            if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
//                                self.btnContinue.alpha = 1
//                                self.btnContinue.isEnabled = true
//                            }
//                        }else{
//                            if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
//                                self.btnContinue.alpha = 1
//                                self.btnContinue.isEnabled = true
//                            }
//                        }
//                    })
//
//                    cell.mainStack.isHidden = false
//                    if self.comesFromMardArrive == true{
//                        cell.imagesStackView.isHidden = false
//                        cell.imagesArr = imageArr
//                        cell.collectionViewImages.reloadData()
//                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
//                    }else{
//                        self.deliveryImages = imageArr
//                        cell.deliveryStackView.isHidden = false
//                        cell.deliveryImagesArr = imageArr
//                        cell.collectionVwDropOffImgs.reloadData()
//                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
//                    }
//                }
//                else
//                {
//
//                    self.imgArr = imageArr
//                    self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
//
//                        if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
//                            Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
//                        }
//                        self.deliveryPackages?[indexPath.row].delivery_status = self.comesFromMardArrive == true ? 1 : 4
//                        cell.btnAccept.isEnabled = false
//                        cell.btnreject.isEnabled = false
//                        cell.btnAccept.alpha = 0.4
//                        cell.btnreject.alpha = 0.4
//
//                        if self.comesFromMardArrive == true{
//                            if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
//                                self.btnContinue.alpha = 1
//                                self.btnContinue.isEnabled = true
//                            }
//                        }else{
//                            if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
//                                self.btnContinue.alpha = 1
//                                self.btnContinue.isEnabled = true
//                            }
//                        }
//                    })
//
//                    cell.mainStack.isHidden = false
//                    if self.comesFromMardArrive == true{
//                        cell.imagesStackView.isHidden = false
//                        cell.imagesArr = imageArr
//                        cell.collectionViewImages.reloadData()
//                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
//                    }else{
//                        self.deliveryImages = imageArr
//                        cell.deliveryStackView.isHidden = false
//                        cell.deliveryImagesArr = imageArr
//                        cell.collectionVwDropOffImgs.reloadData()
//                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
//                    }
//                    DispatchQueue.main.async
//                    {
//                        self.tblView.reloadData()
//                    }
//
//                }
//            }
//            self.present(vc, animated: true)
//        }
        
        cell.didPressReject = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelTripVC") as! CancelTripVC
            vc.modalPresentationStyle = .overFullScreen
            vc.deliveryPackage = true
            vc.comesFromMardArrive = self.comesFromMardArrive
            vc.cancelTripCallBack = { imageArr,reasonStr in
                print(imageArr)
                print(reasonStr)
                
                
                if self.comesFromMardArrive == true{
                    cell.imagesStackView.isHidden = false
                    self.deliveryPackages?[indexPath.row].package_image_while_pickup = imageArr
                    cell.collectionViewImages.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        
                        self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:reasonStr,AcceptTrip:false,comerFromMarkArive:true, completion: {
                            
                            
                            
                            if self.viewModal.objPackageStatusModal?.data?.message  != nil{
                                
                                let story = UIStoryboard(name: "PostLogin", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "VDLogoutVC") as! VDLogoutVC
                                vc.descriptionText = self.viewModal.objPackageStatusModal?.message ?? ""
                                vc.rejectPackage = true
                                vc.modalPresentationStyle = .overFullScreen
                                vc.cancelCallBack = { cancel in
                                    if cancel {
                                        
                                    }
                                    
                                }
                                vc.sucessCallback = { sucess in
                                    if sucess {
                                        cell.btnAccept.isEnabled = false
                                        cell.btnreject.isEnabled = false
                                        cell.btnAccept.alpha = 0.4
                                        cell.btnreject.alpha = 0.4
                                        guard let tripID = sharedAppDelegate.notficationDetails?.trip_id else {return}
                                        guard let customerID = sharedAppDelegate.notficationDetails?.customer_id else {return}
                                        self.viewModel.cancelRideApi(tripID, customerID, reasonStr)
                                        //  SKToast.show(withMessage: "Ride has been Cancelled by you.")
                                        self.navigationController?.popToRootViewController(animated: true)
                                        
                                    }
                                }
                                self.present(vc, animated: true)
                                
                            }
                            else
                            {
                                self.deliveryPackages?[indexPath.row].delivery_status = 5
                                cell.btnAccept.isEnabled = false
                                cell.btnreject.isEnabled = false
                                cell.btnAccept.alpha = 0.4
                                cell.btnreject.alpha = 0.4
                            }
                            
                            
                            //  if imageArr.count != 0{
                            if self.comesFromMardArrive == true{
                                if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
                                    self.btnContinue.alpha = 1
                                    self.btnContinue.isEnabled = true
                                    if imageArr.count != 0{
                                        self.imgArr = imageArr
                                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                                    }
                                    
                                }
                            }else{
                                if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
                                    self.btnContinue.alpha = 1
                                    self.btnContinue.isEnabled = true
                                    if imageArr.count != 0{
                                        self.deliveryImages = imageArr
                                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                                    }
                                }
                            }
                        })
                    }
                }else{
                    cell.deliveryStackView.isHidden = false
                    self.deliveryPackages?[indexPath.row].package_image_while_drop_off = imageArr
                    cell.collectionVwDropOffImgs.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        print("done")
                        
                        self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:reasonStr,AcceptTrip:false,comerFromMarkArive: false, completion: {
                            if self.viewModal.objPackageStatusModal?.data?.message  != nil{
                                
                                let story = UIStoryboard(name: "PostLogin", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "VDLogoutVC") as! VDLogoutVC
                                vc.descriptionText = self.viewModal.objPackageStatusModal?.message ?? ""
                                vc.rejectPackage = true
                                vc.modalPresentationStyle = .overFullScreen
                                vc.cancelCallBack = { cancel in
                                    if cancel {
                                        
                                    }
                                    
                                }
                                vc.sucessCallback = { sucess in
                                    if sucess {
                                        cell.btnAccept.isEnabled = false
                                        cell.btnreject.isEnabled = false
                                        cell.btnAccept.alpha = 0.4
                                        cell.btnreject.alpha = 0.4
                                        guard let tripID = sharedAppDelegate.notficationDetails?.trip_id else {return}
                                        guard let customerID = sharedAppDelegate.notficationDetails?.customer_id else {return}
                                        self.viewModel.cancelRideApi(tripID, customerID, reasonStr)
                                        //  SKToast.show(withMessage: "Ride has been Cancelled by you.")
                                        self.navigationController?.popToRootViewController(animated: true)
                                        
                                    }
                                }
                                self.present(vc, animated: true)
                                
                            }
                            else
                            {
                                cell.btnAccept.isEnabled = false
                                cell.btnreject.isEnabled = false
                                cell.btnAccept.alpha = 0.4
                                cell.btnreject.alpha = 0.4
                            }
                            if self.comesFromMardArrive == true{
                                if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
                                    self.btnContinue.alpha = 1
                                    self.btnContinue.isEnabled = true
                                    if imageArr.count != 0{
                                        self.imgArr = imageArr
                                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                                    }
                                }
                            }else{
                                if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
                                    self.btnContinue.alpha = 1
                                    self.btnContinue.isEnabled = true
                                    if imageArr.count != 0{
                                        self.deliveryImages = imageArr
                                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                                    }
                                }
                            }
                        })
                    }
                    
                    
                }
                self.tblView.reloadData()
                
                
                
                // }
            }
            self.present(vc, animated: true)
            
        }
        //        if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
        //
        //            cell.btnAccept.isEnabled = false
        //            cell.btnreject.isEnabled = false
        //            cell.btnAccept.alpha = 0.4
        //            cell.btnreject.alpha = 0.4
        //
        //        }else{
        //            cell.btnAccept.isEnabled = true
        //            cell.btnreject.isEnabled = true
        //            cell.btnAccept.alpha = 1
        //            cell.btnreject.alpha = 1
        //        }
        return cell
    }
    
    @objc func didPressAccept(_ sender : UIButton)
    {
        
        var index = sender.tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadPackageVC") as! UploadPackageVC
        vc.driver_package_images = self.driver_package_images
        vc.modalPresentationStyle = .overFullScreen
        vc.acceptTripCallBack = { imageArr in
            print(imageArr)
            if imageArr.count != 0{
                
                self.imgArr = imageArr
                self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[index].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
                    
                    if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
                        Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
                    }
                    
                    self.deliveryPackages?[index].delivery_status = self.comesFromMardArrive == true ? 1 : 4

                    if self.comesFromMardArrive == true{
                        self.deliveryPackages?[index].package_image_while_pickup = imageArr
                        if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
                            self.btnContinue.alpha = 1
                            self.btnContinue.isEnabled = true
                        }
                    }else{
                        self.deliveryPackages?[index].package_image_while_drop_off = imageArr
                        if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
                            self.btnContinue.alpha = 1
                            self.btnContinue.isEnabled = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        self.tblView.reloadData()
                    }
                })
               
               
            }
            else
            {
                
                self.imgArr = imageArr
                self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[index].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
                    
                    if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
                        Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
                    }
                    self.deliveryPackages?[index].delivery_status = self.comesFromMardArrive == true ? 1 : 4

                    
                    if self.comesFromMardArrive == true{
                        if self.viewModal.objPackageStatusModal?.data?.can_start == 1{
                            self.btnContinue.alpha = 1
                            self.btnContinue.isEnabled = true
                        }
                    }else{
                        if self.viewModal.objPackageStatusModal?.data?.can_end == 1{
                            self.btnContinue.alpha = 1
                            self.btnContinue.isEnabled = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        self.tblView.reloadData()
                    }
                })
                

               
                
            }
        }
        self.present(vc, animated: true)
    }
    func didSelectItem(url: String) {
        // Navigate to a new view controller
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        detailVC.url = url
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
}

