//
//  VDChatVC.swift
//  VenusDriver
//
//  Created by Amit on 25/06/23.
//

import UIKit
import MobileCoreServices
import Foundation
import UIKit.UITableView
import SDWebImage
class VDChatVC: VDBaseVC {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var tripID = ""
    var customer_id = ""
    var objGetAllMessages : GetAllMessages?
    var name = ""
    var profileImg = ""
    var txtArr = ["Hello?","Where are you?","Have you reached at pickup?","I am at pickup point."]
    var aiMessage = ""
    var appendOnece = true
    //  To create ViewModel
//    static func create() -> UIViewController {
//        let obj = VDChatVC.instantiate(fromAppStoryboard: .postLogin)
//        return obj
//    }

    override func initialSetup() {
        
        
        getAllMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        lblName.text = name
     
//            self.imgViewProfile.setImage(withUrl: profileImg) { status, image in}
        self.imgViewProfile.sd_setImage(with: URL(string: profileImg), placeholderImage: VDImageAsset.imgPlaceholder.asset, options: [.refreshCached, .highPriority], completed: nil)
        let listner = "\(tripID)_\(UserModel.currentUser.login?.user_id ?? 0)"
        VCSocketServices.shared.listnMessage(listnr: listner)
        VCSocketServices.shared.listneAllMessage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .getAllMessages, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(updateSingleMessage(_:)), name: NSNotification.Name.getSingleMessage, object: nil)
       
    }
    

    @objc func updateSingleMessage(_ notification: Notification) {
        // Ensure notification has model data
        guard let modelData = notification.userInfo?["model"] as? Data else { return }
        
        do {
            // Decode the single message model
            let singleMessage = try JSONDecoder().decode(ThreadData.self, from: modelData)
            
            // Check if `objGetAllMessages` exists, if not, initialize it
            if self.objGetAllMessages == nil {
               // self.objGetAllMessages = GetAllMessages(from: [])
            }

                self.objGetAllMessages?.thread?.append(singleMessage)
            
            // Reload the table view data
            self.tblView.reloadData()
            
            // Scroll to the bottom of the table view
            scrollToBottom()
            
        } catch {
            // Handle decoding errors
            print("Decoding error: \(error)")
        }
    }
    

    
    @objc func handleNotification(_ notification: Notification) {
            if let modelData = notification.userInfo?["model"] as? Data {
                do {
                    let threadModel = try JSONDecoder().decode(GetAllMessages.self, from: modelData)
                    // Reverse the order of messages so that the oldest message appears at the bottom
                    self.objGetAllMessages = reverseMessagesOrder(threadModel)
                    self.tblView.reloadData()
                    scrollToBottom()
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }
        
        deinit {
            // Remove observer when the view controller is deallocated
            NotificationCenter.default.removeObserver(self, name: .getAllMessages, object: nil)
        }
    
    private func reverseMessagesOrder(_ model: GetAllMessages) -> GetAllMessages {
           var reversedModel = model
           reversedModel.thread = model.thread?.reversed()
           return reversedModel
       }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func emitMessage(){
        var objc = [String:Any]()
        objc["sender_id"] = UserModel.currentUser.login?.user_id ?? 0
        objc["receiver_id"] = sharedAppDelegate.notficationDetails?.customer_id
        objc["engagement_id"] = tripID
        objc["message"] = messageTV.text ?? ""
        objc["attachment"] = ""
        objc["attachment_type"] = ""
        objc["thumbnail"] = ""
        objc["device_type"] = "1"
        objc["login_type"] = "1"
      
        var params : JSONDictionary {
            return objc
        }
        VCSocketIOManager.shared.emit(with: .send_message, objc, loader: false)
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.getAllMessage()
        }
    }
    
    func sendAIMessage(msg: String){
        var objc = [String:Any]()
        objc["sender_id"] = UserModel.currentUser.login?.user_id ?? ""
        objc["receiver_id"] = sharedAppDelegate.notficationDetails?.customer_id
        objc["engagement_id"] = tripID
        objc["message"] = msg
        objc["attachment"] = ""
        objc["attachment_type"] = ""
        objc["thumbnail"] = ""
        objc["device_type"] = "1"
        objc["login_type"] = "1"
        
      
        var params : JSONDictionary {
            return objc
        }
        VCSocketIOManager.shared.emit(with: .send_message, objc, loader: false)
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.getAllMessage()
        }
      
    }
    
    func getAllMessage(){
        var objc = [String:Any]()
        objc["user_id"] = UserModel.currentUser.login?.user_id ?? ""
        objc["ride_id"] = tripID
       
      var params : JSONDictionary {
            return objc
        }
        VCSocketIOManager.shared.emit(with: .list_of_message, objc, loader: false)
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        
        if !InternetReachability.sharedInstance.isInternetAvailable() {
            Proxy.shared.openSettingApp()
            return
        }
        
        if messageTV.text.isEmptyOrWhitespace(){
            let alert = UIAlertController(title: "", message: "Please Enter your message.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            emitMessage()
            messageTV.text = ""
        }
        
    }
    
}

extension VDChatVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VDColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VDColors.textColor.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type a message..."
            textView.textColor = VDColors.textColorGrey.color
        }
    }
}
extension VDChatVC : UITableViewDataSource, UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objGetAllMessages?.thread?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserModel.currentUser.login?.user_id ?? 0 == self.objGetAllMessages?.thread?[indexPath.row].sender_id{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTblCell", for: indexPath) as! SenderTblCell
            cell.lblSend.text = self.objGetAllMessages?.thread?[indexPath.row].message ?? ""
            cell.lblTime.text = self.objGetAllMessages?.thread?[indexPath.row].created_at ?? ""
            DispatchQueue.main.async {
                cell.viewBase.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 10)
              
            }
            return cell
           
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTblCell", for: indexPath) as! ReceiverTblCell
            cell.lblReceiver.text = self.objGetAllMessages?.thread?[indexPath.row].message ?? ""
            cell.lblTime.text =  self.objGetAllMessages?.thread?[indexPath.row].created_at ?? ""
            DispatchQueue.main.async {
                cell.viewBase.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 10)
               
            }
            return cell
        }
        
    }
    
    private func scrollToBottom() {
         guard let messageCount = objGetAllMessages?.thread?.count, messageCount > 0 else { return }
         let indexPath = IndexPath(row: messageCount - 1, section: 0)
         tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
     }
  
  
    
}

extension UITableView {
    func scrollToBottomRow(animated: Bool) {
        guard self.numberOfSections > 0 else { return }
        
        let lastSection = self.numberOfSections - 1
        guard self.numberOfRows(inSection: lastSection) > 0 else { return }
        
        let lastRow = self.numberOfRows(inSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}
extension VDChatVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return txtArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCollectionCell", for: indexPath) as! chatCollectionCell
        cell.lblText.text = txtArr[indexPath.row]
        return cell
         
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !InternetReachability.sharedInstance.isInternetAvailable() {
            Proxy.shared.openSettingApp()
            return
        }
        sendAIMessage(msg: txtArr[indexPath.row])
    }
}
extension VDChatVC{
    @objc fileprivate func keyboardWillAppear(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardRectValue.height
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        }
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
  
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
         // Additional logic if needed when the text field begins editing
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         // Additional logic if needed when the text field ends editing
     }
}
