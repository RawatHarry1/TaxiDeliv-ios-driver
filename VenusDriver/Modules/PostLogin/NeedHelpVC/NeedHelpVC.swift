//
//  NeedHelpVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 04/07/24.
//

import UIKit

class NeedHelpVC: UIViewController, UITextViewDelegate {

    var isROR = false
    var notficationDetails: PushNotification?
    var viewModel = FeedbackVM()
    var objEndTripModal: EndRideModel?
    
    @IBOutlet weak var txtView: IQTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.delegate = self
       
    }
    
    func generateTicket(){
        var feeback = txtView.text ?? ""
        if txtView.text == "" {
            feeback = ""
        }
        
        if feeback == "" {
            alert()
           // SKToast.show(withMessage: "Please enter feedback.")
            return
        }
       
        var params : JSONDictionary {
            if self.isROR == true
            {
                let att: [String:Any] = [
                    "support_id": "11",
                    "issue_title": txtView.text ?? "",
                    "ride_date" : notficationDetails?.date ?? "",
                    "engagement_id": notficationDetails?.trip_id ?? 0,
                ] as [String : Any]
                return att
            }
            else
            {
                let att: [String:Any] = [
                    "support_id": "11",
                    "issue_title": txtView.text ?? "",
                    "ride_date" : objEndTripModal?.driver_ride_date ?? "",
                    "engagement_id": objEndTripModal?.engagement_id ?? 0,
                ] as [String : Any]
                return att

            }
         
        }
        viewModel.generateSupportTicket(params) {
            //self.dismiss(animated: true, completion: {
            self.SubmitAlert()
           // })
        }
    }
    
    func alert(){
        let refreshAlert = UIAlertController(title: "", message: "Please enter feedback.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
           
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func SubmitAlert(){
        let refreshAlert = UIAlertController(title: "", message: "Your feedback submitted successfully!.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            VDRouter.goToSaveUserVC()
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        generateTicket()
       
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension NeedHelpVC{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Prevent space as the first character
        if range.location == 0 && text == " " {
            return false
        }
        return true
    }
}
