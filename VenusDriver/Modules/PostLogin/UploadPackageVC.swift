//
//  UploadPackageVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/11/24.
//

import UIKit

struct UplodPhotoModal : Codable {
    let message : String?
    let flag : Int?
    let data : UplodPhotoData?

}
struct UplodPhotoData : Codable {
    let file_path : String?
}

class UploadPackageVC: UIViewController {
    @IBOutlet weak var collecetionVw: UICollectionView!
    
    var selectedImage: UIImage?
    var uploadedImages: [UIImage] = []
    var data_img: Data?
    var name_img:String?
    var viewModal = UploadPhotoViewModal()
    var arrImages = [String]()
    var acceptTripCallBack: (([String]) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrImages.removeAll()
      
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        print(arrImages)
      
        if uploadedImages.count == 0{
           // SKToast.show(withMessage: "Please Upload Images!!")
            self.showAlert(withTitle: "Alert", message: "Please Upload Images!!", on: self)
        }else{
            self.dismiss(animated: true) { [self] in
                self.acceptTripCallBack!(self.arrImages)
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
extension UploadPackageVC: UploadFileAlertDelegates {
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

extension UploadPackageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        return CGSizeMake(100, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < uploadedImages.count {
            
        }else{
            UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
        }
    }
    
}
