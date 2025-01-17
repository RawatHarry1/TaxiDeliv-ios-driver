//
//  CancelTripVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 13/11/24.
//

import UIKit

class CancelTripVC: UIViewController {
    @IBOutlet weak var collecetionVw: UICollectionView!
    
    
    @IBOutlet weak var tblView: UITableView!
    var selectedImage: UIImage?
    var deliveryPackage = false
    var comesFromMardArrive = false
    var uploadedImages: [UIImage] = []
    var data_img: Data?
    var name_img:String?
    var viewModal = UploadPhotoViewModal()
    @IBOutlet weak var descriptionLbl: UILabel!
    var arrImages = [String]()
    var selectedIndex = -1
    @IBOutlet weak var btnConfirm: VDButton!
    var cancelTripCallBack: (([String],String) -> Void)?
    var reason = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.rowHeight = 50
        reason = ""
        arrImages.removeAll()
        if deliveryPackage == true
        {
            btnConfirm.setTitle( comesFromMardArrive == true ?  "REJECT" : "NOT DELIVERED", for: .normal)
            btnConfirm.backgroundColor = UIColor.red
            descriptionLbl.text = "Reason For Rejection"
        }
       
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        print(arrImages)
        if reason == ""{
            //SKToast.show(withMessage: "Please Select Reason!!")
            self.showAlert(withTitle: "Alert", message: "Please Select Reason!!", on: self)
        }else{
            self.dismiss(animated: true) { [self] in
                self.cancelTripCallBack!(self.arrImages,self.reason)
            }
        }
    }
    
    func showAlert(withTitle title: String, message: String, on viewController: UIViewController) {
        // Create the alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" action button
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
}


//MARK: UploadFileAlertDelegates
extension CancelTripVC: UploadFileAlertDelegates {
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            self.selectedImage = UIImage(data: dt)
           
            self.data_img = data
            self.name_img = name
            uploadedImages.append(self.selectedImage!)
            collecetionVw.reloadData()
            
            let param : [String:Any] = ["trip_id":sharedAppDelegate.notficationDetails?.trip_id ?? ""]
            viewModal.uploadPhoto(param, self.selectedImage!, completion: {
                self.arrImages.append(self.viewModal.objUplodPhotoModal?.data?.file_path ?? "")
            })
        }
    }
}

extension CancelTripVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModel.currentUser.login?.delivery_cancellation_reasons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelTripTblCell", for: indexPath) as! CancelTripTblCell
        let obj = UserModel.currentUser.login?.delivery_cancellation_reasons?[indexPath.row]
        cell.lblReason.text = obj
        if selectedIndex == indexPath.row{
            self.reason = obj ?? ""
            cell.imgViewCheckBox.image = UIImage(named: "tick")
            cell.imgViewCheckBox.backgroundColor = UIColor(named: "buttonSelectedOrange")
        }else{
            cell.imgViewCheckBox.image = UIImage(named: "")
            cell.imgViewCheckBox.backgroundColor = .systemGray2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tblView.reloadData()
    }
    
}

extension CancelTripVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < uploadedImages.count {
            // Show uploaded image cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
            cell.imgViewImages.image = uploadedImages[indexPath.item]
            return cell
        } else {
            // Show upload button cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionCell", for: indexPath) as! UploadCollectionCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(80, 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < uploadedImages.count {
            
        }else{
            UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
        }
    }
    
}
