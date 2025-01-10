//
//  UploadPackageVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/11/24.
//

import UIKit
import SDWebImage


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
    var arrImages = [""]
    var appendedArr = [String]()
    var acceptTripCallBack: (([String]) -> Void)?
  //  var appendedArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrImages.removeAll(keepingCapacity: true)
        self.uploadedImages.removeAll()
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        print(arrImages)
      
        if appendedArr.count == 0{
           // SKToast.show(withMessage: "Please Upload Images!!")
            self.showAlert(withTitle: "Alert", message: "Please Upload Images!!", on: self)
        }else{
            self.dismiss(animated: true) { [self] in
                self.acceptTripCallBack!(self.appendedArr)
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
            //  uploadedImages.append(self.selectedImage!)
            
            
            let param : [String:Any] = ["trip_id":sharedAppDelegate.notficationDetails?.trip_id ?? ""]
            viewModal.uploadPhoto(param, self.selectedImage!) { [weak self] in
                guard let self = self else { return }
  
                
                    
                    // Safely extract the file path
                    if let filePath = self.viewModal.objUplodPhotoModal?.data?.file_path {
                        let uniqueFilePath = filePath // Copy the value to a unique variable
                        appendedArr.append(uniqueFilePath) // Append the unique string
                    } else {
                        print("Error: file_path is nil")
                    }

                    // Reload the collection view on the main thread
                    DispatchQueue.main.async {
                        self.collecetionVw.reloadData()
                    }
            }
        }
    }
}

extension UploadPackageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appendedArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < appendedArr.count{
            // Show uploaded image cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell2", for: indexPath) as! ImagesCollectionCell2
            
            // Assign the correct image
            cell.imgViewImages.loadImage(from: URL(string: appendedArr[indexPath.item])!)
            
            // Handle delete action using a closure
            cell.didPressDelete = { [weak self] in
                guard let self = self else { return }
                
                // Ensure the index is valid before attempting to delete
                if indexPath.item < appendedArr.count {
                    appendedArr.remove(at: indexPath.item)
                    collectionView.reloadData() // Reload the collection view to reflect changes
                }
            }
            
            return cell
        } else {
            // Show upload button cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionCell", for: indexPath) as! UploadCollectionCell
            return cell
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake((collecetionVw.frame.width / 3) - 5, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < appendedArr.count {
            
        }else{
            UploadFileAlert.sharedInstance.showCamera2(vc: self, self)// alert(self, .profile , false, self)
        }
    }
}
