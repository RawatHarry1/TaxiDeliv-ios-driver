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
    
    var deliveryPackages : [DeliveryPackages]?
    var viewModal = UploadPhotoViewModal()
    var didPressContinue: (() -> Void)?
    var comesFromMardArrive = false
    var deliveryImages = [String]()
    var imgArr = [String]()
    
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
        cell.delegate = self
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
            if self.imgArr.count  > 0{
                cell.btnAccept.isEnabled = false
                cell.btnreject.isEnabled = false
                cell.btnAccept.alpha = 0.4
                cell.btnreject.alpha = 0.4
                cell.imagesArr = self.imgArr
                cell.collectionViewImages.reloadData()
                cell.imagesStackView.isHidden = false
            }else{
                cell.btnAccept.isEnabled = true
                cell.btnreject.isEnabled = true
                cell.btnAccept.alpha = 1
                cell.btnreject.alpha = 1
                cell.imagesStackView.isHidden = true
            }
            cell.deliveryStackView.isHidden = true
            cell.btnAccept.setTitle("ACCEPT", for: .normal)
            cell.btnreject.setTitle("REJECT", for: .normal)
        }else{
            if self.deliveryPackages?[indexPath.row].delivery_status ?? 0 == 5{
                cell.imagesStackView.isHidden = false
                cell.deliveryStackView.isHidden = false
                cell.mainStack.isHidden = false
            }else{
                if self.deliveryImages.count > 0{
                    cell.btnAccept.isEnabled = false
                    cell.btnreject.isEnabled = false
                    cell.btnAccept.alpha = 0.4
                    cell.btnreject.alpha = 0.4
                    cell.deliveryImagesArr = self.deliveryImages
                    cell.collectionVwDropOffImgs.reloadData()
                    cell.deliveryStackView.isHidden = false
                }else{
                    cell.btnAccept.isEnabled = true
                    cell.btnreject.isEnabled = true
                    cell.btnAccept.alpha = 1
                    cell.btnreject.alpha = 1
                    cell.deliveryStackView.isHidden = true
                }
                cell.imagesStackView.isHidden = false
               
                cell.mainStack.isHidden = false
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
 
                    self.imgArr = imageArr
                    self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:"",AcceptTrip:true,comerFromMarkArive:self.comesFromMardArrive, completion: {
                        
                        if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
                            Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
                        }
                        
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
                    
                    cell.mainStack.isHidden = false
                    if self.comesFromMardArrive == true{
                        cell.imagesStackView.isHidden = false
                        cell.imagesArr = imageArr
                        cell.collectionViewImages.reloadData()
                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                    }else{
                        self.deliveryImages = imageArr
                        cell.deliveryStackView.isHidden = false
                        cell.deliveryImagesArr = imageArr
                        cell.collectionVwDropOffImgs.reloadData()
                        self.tblView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            self.present(vc, animated: true)
        }
        
        cell.didPressReject = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelTripVC") as! CancelTripVC
            vc.modalPresentationStyle = .overFullScreen
            vc.cancelTripCallBack = { imageArr,reasonStr in
                print(imageArr)
                print(reasonStr)
              
                    
                    if self.comesFromMardArrive == true{
                        cell.imagesStackView.isHidden = false
                        cell.imagesArr = imageArr
                        cell.collectionViewImages.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            
                            
                            self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:reasonStr,AcceptTrip:false,comerFromMarkArive:true, completion: {
                                if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
                                    Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
                                }
                                cell.btnAccept.isEnabled = false
                                cell.btnreject.isEnabled = false
                                cell.btnAccept.alpha = 0.4
                                cell.btnreject.alpha = 0.4
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
                        cell.deliveryImagesArr = imageArr
                        cell.collectionVwDropOffImgs.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            print("done")
                            
                            self.viewModal.deliveriPackageApi(tripID: sharedAppDelegate.notficationDetails?.trip_id ?? "", driverID: "\(UserModel.currentUser.login?.user_id ?? 0)", packageId: "\(self.deliveryPackages?[indexPath.row].package_id ?? 0)", images: imageArr,reason:reasonStr,AcceptTrip:false,comerFromMarkArive: false, completion: {
                                if self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "" != ""{
                                    Proxy.shared.displayStatusCodeAlert(self.viewModal.objPackageStatusModal?.deliveryRestriction ?? "", title: "")
                                }
                                cell.btnAccept.isEnabled = false
                                cell.btnreject.isEnabled = false
                                cell.btnAccept.alpha = 0.4
                                cell.btnreject.alpha = 0.4
                                
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
        return cell
    }
    
    func didSelectItem(url: String) {
        // Navigate to a new view controller
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        detailVC.url = url
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
}

