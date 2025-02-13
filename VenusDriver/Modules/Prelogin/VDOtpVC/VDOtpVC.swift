//
//  VDOtpVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit
import CoreLocation

class VDOtpVC: VDBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpTitleLbl: UILabel!

    @IBOutlet weak var btnResend: UIButton!
    // MARK: - Variables
    var phoneNumber = ""
    var countryCode = ""
    var passcode = ""
    var fullText = ""
    var comesFromSignIn = false
    var currentLocation: CLLocation?
    private var loginViewModel: VDLoginViewModel = VDLoginViewModel()
    var otpStackView = OTPStackView()
     var forRideComplete = false
    //  To create ViewModel
    static func create() -> VDOtpVC {
        let obj = VDOtpVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }
    var rideCompleteOtpCallBack : ((String) -> ()) = { _ in }
    override func initialSetup() {
        if forRideComplete == true
        {
            fullText = "Enter the 4-digit code sent to customer"
            btnResend.isHidden = true
        }
        else
        {
            fullText = "Enter the 4-digit code sent to you at\n \(countryCode)\(phoneNumber)"
            btnResend.isHidden = false

        }
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
        
        self.loginViewModel.successCallBack = { status in
            //SKToast.show(withMessage: "4-digit code has been sent.")
            let alert = UIAlertController(title: "", message: "4-digit code has been sent.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // Show Error Alert
        self.loginViewModel.showAlertClosure = {
            if let error = self.loginViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
        
        self.loginViewModel.otpVerifiedCallBack = { userMainModel in
            var userModel = userMainModel
            if let loginModel = userModel.login {
                userModel.passcode = self.passcode
                UserModel.currentUser = userModel
                if UserModel.isAllStepsCompleted(loginModel.registration_step_completed!, loginModel.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                    VDRouter.goToSaveUserVC()
//                    self.navigationController?.pushViewController(VDLGMainVC.create(), animated: true)
                } else {
                    // Check for step missing
                    let missingStep = UserModel.incompleteStep(loginModel)
                    switch missingStep {
                    case .profile:
                        self.navigationController?.pushViewController(VDCreateProfileVC.create(), animated: true)
                    case .document_upload:
                        self.navigationController?.pushViewController(VDDocumentVC.create(1), animated: true)
                    case .vehicle_info:
                       var vc = VDElectricVC.create()
                        vc.fromOTP = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .bank_details:
                       // VDRouter.goToSaveUserVC()
//                        self.navigationController?.pushViewController(VDLGMainVC.create(), animated: true)
                        self.navigationController?.pushViewController(VDPayoutInfoVC.create(), animated: true)
                    case .none:
                        VDRouter.goToSaveUserVC()
//                        self.navigationController?.pushViewController(VDLGMainVC.create(), animated: true)
                    }
                }
            } else {
                printDebug("===========Login data not found==============")
                SKToast.show(withMessage: "Something went wrong please try agian later.")
            }
        }

        titleLabelAttributes()
    }


    func titleLabelAttributes() {
        let clickAble = "\(countryCode)\(phoneNumber)"

        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: VDColors.buttonSelectedOrange.color.cgColor, range: rangeClickableText)
        otpTitleLbl.attributedText = attributedString
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendCode(_ sender: Any) {
        if comesFromSignIn == true{
            loginViewModel.validateLoginDetails(countryCode, phoneNumber, currentLocation)
        }else{
            loginViewModel.validateLoginDetails(countryCode, phoneNumber, currentLocation)
        }
       
    }
    
}

extension VDOtpVC: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if isValid {
            if self.forRideComplete == true
            {
                let otp = self.otpStackView.getOTP()
                rideCompleteOtpCallBack(otp)
            }
            else
            {
                let otp = self.otpStackView.getOTP()

                var attribute = [String : Any]()
                attribute["loginOtp"] = otp
                attribute["phoneNo"] = phoneNumber
                attribute["countryCode"] = countryCode
                if let location = LocationTracker.shared.lastLocation {
                    attribute["latitude"] = location.coordinate.latitude
                    attribute["longitude"] = location.coordinate.longitude
                }
                if self.passcode != ""
                {
                    attribute["passcode"] = self.passcode

                }

                loginViewModel.loginWithOtp(attribute, failer: { errorMessage in
                    print("Error: \(errorMessage)")
                    
                    let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
           
        }
    }
}
