//
//  PackageListVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/11/24.
//

import UIKit

class PackageListVC: UIViewController {

    @IBOutlet weak var btnContinue: VDButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    var deliveryPackages : [DeliveryPackages]?
    var viewModal = UploadPhotoViewModal()
    var didPressContinue: (() -> Void)?
    var comesFromMardArrive = false
    var deliveryImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnContinue.alpha = 0.4
        btnContinue.isEnabled = false
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        self.didPressContinue!()
        self.navigationController?.popViewController(animated: true)
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
        
        
        
        if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
            cell.lblStatus.text = "Not Picked"
            cell.lblStatus.textColor = .systemRed
            cell.viewStatus.isHidden = false
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
       
        if comesFromMardArrive == true{
            cell.deliveryStackView.isHidden = true
            cell.imagesStackView.isHidden = false
            cell.btnAccept.setTitle("ACCEPT", for: .normal)
            cell.btnreject.setTitle("REJECT", for: .normal)
          
        }else{
            if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
                cell.imagesStackView.isHidden = true
                cell.deliveryStackView.isHidden = true
            }else{
                cell.imagesStackView.isHidden = false
                cell.deliveryStackView.isHidden = false
            }
           
            cell.btnAccept.setTitle("DELIVERED", for: .normal)
            cell.btnreject.setTitle("NOT DELIVERED", for: .normal)
        }
        
        cell.didPressAccept = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadPackageVC") as! UploadPackageVC
            vc.modalPresentationStyle = .overFullScreen
            vc.acceptTripCallBack = { imageArr in
                print(imageArr)
                if imageArr.count != 0{
                    
                    
                    if self.comesFromMardArrive == true{
                        cell.imagesStackView.isHidden = false
                        cell.imagesArr = imageArr
                        cell.collectionViewImages.reloadData()
                    }else{
                        cell.deliveryStackView.isHidden = false
                        cell.deliveryImagesArr = imageArr
                        cell.collectionVwDropOffImgs.reloadData()
                        self.view.setNeedsLayout()
                    }
                   
                }
                self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
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
                   
                })
            }
            self.present(vc, animated: true)
         
        }
        
        cell.didPressReject = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelTripVC") as! CancelTripVC
            vc.modalPresentationStyle = .overFullScreen
            vc.cancelTripCallBack = { imageArr,reasonStr in
                print(imageArr)
                print(reasonStr)
                if imageArr.count != 0{
                   
                    if self.comesFromMardArrive == true{
                        cell.imagesStackView.isHidden = false
                        cell.imagesArr = imageArr
                        cell.collectionViewImages.reloadData()
                        
                    }else{
                        cell.deliveryStackView.isHidden = false
                        cell.deliveryImagesArr = imageArr
                        cell.collectionVwDropOffImgs.reloadData()
                        
                    }
                    self.tblView.reloadData()
                   
                }
                self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:reasonStr,AcceptTrip:false,comerFromMarkArive:self.comesFromMardArrive, completion: {
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
                    
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
                })
            }
            self.present(vc, animated: true)
            
        }
        return cell
    }
}

