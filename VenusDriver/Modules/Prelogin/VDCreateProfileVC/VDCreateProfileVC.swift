//
//  VDCreateProfileVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit
import AVFoundation

class VDCreateProfileVC: VDBaseVC {

    // MARK: - outlets
    @IBOutlet weak var phoneNumberTF: SkyfieldPhoneTF!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNameTF: SkyfieldTF!
    @IBOutlet weak var lastNameTF: SkyfieldTF!
    @IBOutlet weak var userNameTF: SkyfieldTF!
    @IBOutlet weak var emailTF: SkyfieldTF!
    @IBOutlet weak var addressLineTF: SkyfieldTF!
    @IBOutlet weak var addressLine2TF: SkyfieldTF!
    @IBOutlet weak var postalCodeTF: SkyfieldTF!

    var screenType = 0
    var data_img: Data?
    var name_img:String?
    var createProfileViewModel: VDCreateProfileViewModel = VDCreateProfileViewModel()
    var userProfileModel: UserProfileModel?
    var comesFromEditProfile = false
    var didPressDismiss: (()->Void)?
    //  To create ViewModel
    static func create(_ type: Int = 0) -> VDCreateProfileVC {
        let obj = VDCreateProfileVC.instantiate(fromAppStoryboard: .preLogin)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        phoneNumberTF.setLeftPaddingPoints(40.0)
        phoneNumberTF.leftPadding = 40
        titleLabel.text = (screenType != 0) ? "Edit Your Profile" : "Create Your Profile"
        if screenType == 1 {
            setUpProfileData()
        }
        
        if comesFromEditProfile == true{
          
        }else{
          
        }

        firstNameTF.delegate = self
        lastNameTF.delegate = self
        userNameTF.delegate = self
//        profileImgView.image = profileImgView.image?.withRenderingMode(.alwaysTemplate)
//        profileImgView.tintColor = VDColors.buttonSelectedOrange.color

        // Show Error Alert
        self.createProfileViewModel.showAlertClosure = {
            if let error = self.createProfileViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }

        self.createProfileViewModel.successCallBack = { status in
            if self.screenType == 0 {
                self.navigationController?.pushViewController(VDSignUpCompleteVC.create(), animated: true)
            } else {
                self.dismiss(animated: true) {
                    self.didPressDismiss!()
                }
            }
        }
    }
    
 

    func setUpProfileData() {
        guard let profileData = userProfileModel else { return }
        firstNameTF.text = profileData.first_name ?? ""
        lastNameTF.text = profileData.last_name ?? ""
        userNameTF.text = profileData.name ?? ""
        emailTF.text = profileData.email ?? ""
//        if let address = profileData.address {
//            let addressArr = address.components(separatedBy: ",")
//            if addressArr.count > 0 {
//                addressLineTF.text = addressArr[0]
//                if addressArr.count > 1 {
//                    addressLine2TF.text = addressArr[1]
//                    if addressArr.count > 2 {
//                        postalCodeTF.text = addressArr[2]
//                    }
//                }
//            }
//        }

        addressLineTF.text = profileData.address ?? "-"

        if let urlStr = profileData.driver_image {
            self.profileImgView.setImage(withUrl: urlStr) { status, image in
                if status {
                    if let img = image {
                        self.data_img = img.jpegData(compressionQuality: 1.0)
                        self.profileImgView.image = img
                    }
                }
            }
        }
    }
}

extension VDCreateProfileVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.firstNameTF || textField == lastNameTF || textField == userNameTF {
            var validString = CharacterSet()
            if textField == self.userNameTF {
                validString = CharacterSet(charactersIn: " !@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
            }else{
                validString = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
            }
           

            if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
                return false
            }
            if let range = string.rangeOfCharacter(from: validString)
            {
                return false
            }
        }
        return true
    }
    
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
               DispatchQueue.main.async {
                   UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
               }
           case .restricted, .denied:
               // The user has previously denied access or access is restricted
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

extension VDCreateProfileVC {
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)

        var img : UIImage?
        if self.self.data_img != nil {
            img = self.profileImgView.image
        }

        createProfileViewModel.validateLoginDetails(
            (firstNameTF.text ?? "").trimmed,
            (lastNameTF.text ?? "").trimmed,
            (userNameTF.text ?? "").trimmed,
            (emailTF.text ?? "").trimmed,
            (addressLineTF.text ?? ""),
            (addressLine2TF.text ?? ""),
            (postalCodeTF.text ?? "").trimmed,
            (phoneNumberTF.text ?? "").trimmed,
            img, completion: { str in
                let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                //SKToast.show(withMessage: error.localizedDescription)
            }
        )
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if comesFromEditProfile == true{
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popBack(2)
          //  self.navigationController?.popViewController(animated: true)
           // let vc = navigationController!.viewControllers.filter { $0 is VDSignUpVC }.first!
              //   navigationController!.popToViewController(vc, animated: true)
        }
       
    }

    @IBAction func openCountryPickerBtn(_ sender: UIButton) {
        let vc = CountryCodeVC.create()
        vc.modalPresentationStyle = .overFullScreen
//        vc.country_list = self.countrylist
        vc.countryCodeSelected = { dialCode in
//            self.dialcode = dialCode
//            self.btn_dialcode.setTitle("+" + dialCode, for: .normal)
        }
        self.present(vc, animated: true)
    }

    @IBAction func selectImage(_ sender: UIButton) {
        requestCameraPermission()
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

//MARK: UploadFileAlertDelegates
extension VDCreateProfileVC: UploadFileAlertDelegates {
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            self.profileImgView.image = UIImage(data: dt)
            self.data_img = data
            self.name_img = name
        }
    }
}
extension UINavigationController {
    func popBack(_ count: Int) {
        guard count > 0 else {
            return assertionFailure("Count can not be a negative value.")
        }
        let index = viewControllers.count - count - 1
        guard index > 0 else {
            return assertionFailure("Not enough View Controllers on the navigation stack.")
        }
        popToViewController(viewControllers[index], animated: true)
    }
}
