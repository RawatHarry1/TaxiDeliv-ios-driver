//
//  LuggageVC.swift
//  VenusDriver
//
//  Created by TechBuilder on 13/02/25.
//

import UIKit

class LuggageVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfLuggage: UITextField!
    var luggageEntered: ((Int) -> Void)?
  //  var appendedArr = [String]()
    var forPeople = false
    var maxPeople = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLuggage.text = "0"
        lblHeading.text = forPeople == true ? "Enter No. of People" : "Enter Luggage Count"
        tfLuggage.delegate = self
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
      
        if tfLuggage.text?.isEmpty == true  {
        
                self.showAlert(withTitle: "Alert", message: "Please Enter Value!", on: self)

            
           // SKToast.show(withMessage: "Please Upload Images!!")
        }
        else if (Int(tfLuggage.text!) ?? 0) > maxPeople
        {
            self.showAlert(withTitle: "Alert", message: "Please Enter Value less than or equal to \(maxPeople)", on: self)

        }
        else{
            self.dismiss(animated: true) { [self] in
                self.luggageEntered?(Int(tfLuggage.text!) ?? 0)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

//        switch textField {
//            case tfLuggage:
//                //Special case code to handle the phone number field
//                if string == "0" {
//                    if textField.text!.count == 0 {
//                       return false
//                    }
//                    return true
//                }
//
//           
//                //Special case code to handle the name field (if needed.)
//            default:
//            return true
//                //Shared code to handle the other fields the same way
//        }
        return true
    }
}




