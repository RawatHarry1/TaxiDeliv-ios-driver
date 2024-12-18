//
//  RaiseTicketVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 10/12/24.
//

import UIKit
import AVFoundation

class RaiseTicketVC: VCBaseVC {
    
    @IBOutlet weak var txtViewDesc: IQTextView!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var imgViewUploadedImage: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var txtfldReason: UITextField!
    
    var photo : UIImage?
  
    let picker = UIPickerView()
    var objUplodPhotoModal : UplodPhotoModal?
    var imgUrl = ""
    var objViewModal = RaiseTicketVM()
    var rideId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfldReason.placeholder = "Select Reason"
        btnDelete.isHidden = true
        viewDesc.addShadowView()
        viewReason.addShadowView()
        picker.delegate = self
        picker.dataSource = self
        txtfldReason.inputView = picker
        print(UserModel.currentUser.login?.support_ticket_reasons ?? "")
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtfldReason.inputAccessoryView = toolbar
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true)
      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        self.view.endEditing(true)
        self.requestCameraPermission()
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        btnDelete.isHidden = true
        imgViewUploadedImage.image = nil
        photo = nil
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        validation()
    }
    
    func uploadImageApi(img:UIImage){
        let param : [String:Any] = ["trip_id":rideId]
        WebServices.commonPostAPIWithImage(endPoint: .upload_file_driver, parameters: param, image: ["image": self.photo!]) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                let data = try! data.rawData()
                let model = try! JSONDecoder().decode(UplodPhotoModal.self, from: data)
                
                self?.objUplodPhotoModal = model
                self?.imgUrl = self?.objUplodPhotoModal?.data?.file_path ?? ""
              
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func raiseTicketapi(){
        self.objViewModal.raiseTicket(rideID: rideId, subject: lblReason.text ?? "", ticket_image: imgUrl, description: txtViewDesc.text ?? "") {
            SKToast.show(withMessage: self.objViewModal.objTicketModal?.message ?? "")
            self.dismiss(animated: true)
            // self.navigationController?.popViewController(animated: true)
        }
    }
    
    func validation(){
        txtfldReason.resignFirstResponder()
        txtViewDesc.resignFirstResponder()
        if lblReason.text == ""{
            SKToast.show(withMessage: "Please select reason!!")
        }else if txtViewDesc.text == ""{
            SKToast.show(withMessage: "Please enter Description!!")
        }else{
            raiseTicketapi()
        }
    }
}

extension RaiseTicketVC: UploadFileAlertDelegates {
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            
            self.imgViewUploadedImage.image = UIImage(data: dt)
            self.photo = UIImage(data: dt)
            self.btnDelete.isHidden = false
            self.uploadImageApi(img:UIImage(data: dt)!)
        }
    }
}


extension RaiseTicketVC:UIPickerViewDelegate, UIPickerViewDataSource{
    
    @objc func doneTapped() {
        txtfldReason.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserModel.currentUser.login?.support_ticket_reasons?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserModel.currentUser.login?.support_ticket_reasons?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtfldReason.placeholder = ""
        lblReason.text = UserModel.currentUser.login?.support_ticket_reasons?[row]
    }
}

extension RaiseTicketVC{
    
    func requestCameraPermission() {
           let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

           switch cameraAuthorizationStatus {
           case .notDetermined:
               // The user has not yet been asked for camera access
               AVCaptureDevice.requestAccess(for: .video) { granted in
                   if granted {
                       DispatchQueue.main.async {
                           UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
                       }
                      
                   } else {
                       print("Camera access denied")
                   }
               }
           case .authorized:
               // The user has previously granted access
               UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
               print("Camera access previously granted")
           case .restricted, .denied:
               // The user has previously denied access or access is restricted
               DispatchQueue.main.async {
                   UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
               }
               print("Camera access denied or restricted")
               showCameraAccessAlert()
           @unknown default:
               fatalError("Unknown case in camera authorization status")
           }
       }
    
    func showCameraAccessAlert() {
         let alert = UIAlertController(title: "Camera Access Required",
                                       message: "Please enable camera access in Settings to use this feature.",
                                       preferredStyle: .alert)

         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
             guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                 return
             }
             if UIApplication.shared.canOpenURL(settingsUrl) {
                 UIApplication.shared.open(settingsUrl, completionHandler: nil)
             }
         }))

         present(alert, animated: true, completion: nil)
     }
}
