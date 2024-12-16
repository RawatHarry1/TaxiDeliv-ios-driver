//
//  VDSignUpVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit
import CoreLocation

class VDSignUpVC: VDBaseVC {

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
        let obj = VDSignUpVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        phoneTF.delegate = self
        phoneTF.leftPadding = 70
        phoneTF.addLeftViewPadding(70)

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
            vc.comesFromSignIn = false
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
extension VDSignUpVC {
    @IBAction func btnSignUp(_ sender: UIButton) {
        checkLocationServices()
       
//        self.navigationController?.pushViewController(VDOtpVC.create(), animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignIn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.pushViewController(VDLoginVC.create(), animated: true)
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
extension VDSignUpVC : UITextFieldDelegate {
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
extension VDSignUpVC{
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
              loginViewModel.validateLoginDetails(self.dialcode, phoneTF.text ?? "", currentLocation)
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
         // let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

          alertController.addAction(settingsAction)
         // alertController.addAction(cancelAction)

          present(alertController, animated: true, completion: nil)
      }
}
