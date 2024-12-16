//
//  VDTopUPPopVC.swift
//  VenusDriver
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VDTopUPPopVC: VDBaseVC, UITextFieldDelegate {

    @IBOutlet weak var amountTF: VDTextField!

    var parseAmountToAdd:((String) -> Void)?

    //  To create ViewModel
    static func create() -> VDTopUPPopVC {
        let obj = VDTopUPPopVC.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    override func initialSetup() {
        amountTF.delegate = self
        amountTF.addLeftViewPadding(20, false)
    }

    @IBAction func btnAddAmount(_ sender: UIButton) {
        if amountTF.text == ""{
            self.amountTF.resignFirstResponder()
            SKToast.show(withMessage: "Please enter amount!!")
        }else{
            self.dismiss(animated: true) {
                self.parseAmountToAdd?(self.amountTF.text ?? "")
            }
        }
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text after the change
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        // Check if the text starts with 0 and has more than 1 character
        if currentText == "0" && string != "" {
            return false // Prevent entering "0" at the start
        }
        
        return true
    }
}
