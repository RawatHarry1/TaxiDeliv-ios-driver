//
//  VDContactusVC.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

class VDContactusVC: VDBaseVC {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageBaseLineLbl: UILabel!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDContactusVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        messageTextView.textContainerInset = UIEdgeInsets.zero
        messageTextView.textContainer.lineFragmentPadding = 0

        messageBaseLineLbl.backgroundColor = UIColor.lightGray
        messageTextView.textColor = VDColors.textColorGrey.color
        messageTextView.text = "Your Message"
        messageTextView.delegate = self
    }

    @IBAction func btnSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: .openSideMenu, object: nil)
    }
}

extension VDContactusVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VDColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VDColors.textColor.color
        }
        messageBaseLineLbl.backgroundColor = VDColors.textColor.color
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Message"
            textView.textColor = VDColors.textColorGrey.color
        }
        messageBaseLineLbl.backgroundColor = UIColor.lightGray //UIColor(white: 0.88, alpha: 1.0)
    }
}
