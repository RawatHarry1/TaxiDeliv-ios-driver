

import UIKit
import Charts
import NVActivityIndicatorView

//let appDelegate = UIApplication.shared.delegate as! AppDelegate
let storyboardObj = UIStoryboard(name: "Main", bundle: nil)

class Proxy {
    
    static var shared: Proxy {
        return Proxy()
    }
    
    fileprivate init(){}
    func isValidEmail(email: String) -> Bool {
        let regEx =  "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: testStr)
    }
    
    func displayStatusCodeAlert(_ message: String,title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in 
         //   self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(action)
       // UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func documentsNotUploadedCodeAlert(_ message: String,title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            VDRouter.goToSaveUserVC()
          //  sideMenuController.rootViewController = VDHomeVC.create()
        })
        alert.addAction(action)
       // UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    //MARK:- Open Setting Of App
    func openSettingApp() {
        let settingAlert = UIAlertController(title: "Connection Problem", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title: "Setting", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert("Please Review your network settings", title: "")
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            // Present the alert
            keyWindow.rootViewController?.present(settingAlert, animated: true, completion: nil)
        }
    }
}
