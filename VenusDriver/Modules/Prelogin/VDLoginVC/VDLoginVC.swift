//
//  VDLoginVC.swift
//  VenusDriver
//
//  Created by Amit on 08/06/23.
//

import UIKit
import CoreLocation

class VDLoginVC: VDBaseVC {
    // MARK: - Outlets
    @IBOutlet weak var phoneTF: SkyfieldPhoneTF!
    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var flagLabel: UILabel!

    private var loginViewModel: VDLoginViewModel = VDLoginViewModel()
    var dialcode = ""
    var currentLocation: CLLocation?

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDLoginVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func viewWillAppear(_ animated: Bool) {
        self.currentLocation = LocationTracker.shared.lastLocation
    }
}

// MARK: - Custom Functions
extension VDLoginVC {
    
    override func initialSetup() {
        updateUI()
    }
    
    func updateUI() {
        phoneTF.delegate = self
        phoneTF.leftPadding = 70
        phoneTF.addLeftViewPadding(70)
        callBacks()
    }
    
    func callBacks() {
        // Show Error Alert
        self.loginViewModel.showAlertClosure = {
            if let error = self.loginViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }

        self.loginViewModel.successCallBack = { status in
            let vc = VDOtpVC.create()
            vc.phoneNumber = self.phoneTF.text ?? ""
            vc.countryCode = self.dialcode
            vc.comesFromSignIn = true
            vc.currentLocation = self.currentLocation
            self.navigationController?.pushViewController(vc, animated: true)
        }


        let regionCode = Locale.current.regionCode
        let defaultCountry = CountryList.filter({$0.code == regionCode?.replacingOccurrences(of: "+", with: "")})
        if defaultCountry.count > 0 {
            dialcode = "+" + (defaultCountry.first?.dialcode ?? "91")
            self.flagLabel.text = defaultCountry.first?.flag
            self.countryCodeLbl.text = "+" + (defaultCountry.first?.dialcode ?? "")
        }

        self.currentLocation = LocationTracker.shared.lastLocation
        LocationTracker.shared.locateMeCallback = { location in
            self.currentLocation = location
        }
    }
}

// MARK: - IBActions
extension VDLoginVC {
    @IBAction func closeBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnForgotPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDForgotPasswordVC.create(), animated: true)
    }

    @IBAction func btnSignUp(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.navigationController?.pushViewController(VDSignUpVC.create(), animated: true)
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        self.checkLocationServices()
      //  self.view.endEditing(true)
       // loginViewModel.validateLoginDetails(dialcode,phoneTF.text ?? "", currentLocation)
    }

    @IBAction func selectCountryBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = CountryCodeVC.create()
        vc.modalPresentationStyle = .overFullScreen
        vc.countryCodeSelected = { country in
            self.dialcode = "+" + (country.dialcode ?? "")
            self.flagLabel.text = country.flag
            self.countryCodeLbl.text = "+" + (country.dialcode ?? "")
        }
        self.present(vc, animated: true)
    }
}

// MARK: - TextFlield Delegates
extension VDLoginVC : UITextFieldDelegate {
    /// UITextFieldDelegate: ShouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTF {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
}
extension VDLoginVC{
    func checkLocationServices() {
          if CLLocationManager.locationServicesEnabled() {
              // Location services are enabled
              checkLocationAuthorization()
          } else {
              // Location services are not enabled, show alert
              showAlertForLocationSettings()
          }
      }

      func checkLocationAuthorization() {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedWhenInUse, .authorizedAlways:
              // Location is authorized, you can start getting location updates
              locationManager.startUpdatingLocation()
              self.view.endEditing(true)
            loginViewModel.validateLoginDetails(dialcode,phoneTF.text ?? "", currentLocation)
          case .denied, .restricted:
              // User denied location services, show alert
              showAlertForLocationSettings()
          case .notDetermined:
              // First-time permission request
              locationManager.requestWhenInUseAuthorization()
          @unknown default:
              break
          }
      }

      func showAlertForLocationSettings() {
          let alertController = UIAlertController(
              title: "Location Services Off",
              message: "Enable location to receive ride requests from nearby customers and navigate easily to pick-up and drop-off locations.",
              preferredStyle: .alert
          )

          let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                  return
              }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                      print("Settings opened: \(success)") // Prints true
                  })
              }
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

          alertController.addAction(settingsAction)
          alertController.addAction(cancelAction)

          present(alertController, animated: true, completion: nil)
      }
}
