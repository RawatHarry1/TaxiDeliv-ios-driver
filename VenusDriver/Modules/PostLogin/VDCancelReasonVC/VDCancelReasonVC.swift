//
//  VCCancelReasonVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VDCancelReasonVC: VDBaseVC {

    @IBOutlet weak var cancelTableView: UITableView!
    @IBOutlet weak var reasonTV: UITextView!
    
    var selectedReason : ((String) -> ()) = {_ in}

    //  To create ViewModel
    static func create() -> VDCancelReasonVC {
        let obj = VDCancelReasonVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    var selectedReasonIndex = -1

    override func initialSetup() {
        cancelTableView.delegate = self
        cancelTableView.dataSource = self
        cancelTableView.register(UINib(nibName: "VDCancelReasonCell", bundle: nil), forCellReuseIdentifier: "VDCancelReasonCell")

        reasonTV.textContainerInset = UIEdgeInsets.zero
        reasonTV.textContainer.lineFragmentPadding = 0

//        feebackTV.backgroundColor = UIColor.lightGray
        reasonTV.textColor = VDColors.textColorGrey.color
        reasonTV.text = "Please Specify your reason"
        reasonTV.delegate = self
    }

    @objc func selectReasonAction(_ sender: UIButton) {
        if selectedReasonIndex == sender.tag {
            selectedReasonIndex = -1
        } else {
            selectedReasonIndex = sender.tag
        }
        cancelTableView.reloadData()
    }
    
    @IBAction func btnNo(_ sender: VDButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func canceRideBtn(_ sender: Any) {
        if selectedReasonIndex == -1 && (((reasonTV.text ?? "") == "") || (reasonTV.text ?? "") == "Please Specify your reason") {
            SKToast.show(withMessage: "Please Specify your reason")
            return
        } else if selectedReasonIndex == -1 {
            if (((reasonTV.text ?? "") == "") || (reasonTV.text ?? "") == "Please Specify your reason") {
                SKToast.show(withMessage: "Please Specify your reason")
                return
            } else {
                self.selectedReason(reasonTV.text ?? "")
            }
        } else {
            guard let reasons = UserModel.currentUser.login?.cancellation_reasons else {
                SKToast.show(withMessage: "Please Specify your reason")
                return
            }
            self.selectedReason(reasons[selectedReasonIndex])
        }
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension VDCancelReasonVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reasons = UserModel.currentUser.login?.cancellation_reasons else {return 0}
        return reasons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDCancelReasonCell", for: indexPath) as! VDCancelReasonCell
        cell.updateCellUI(index: indexPath.row)
        cell.btnSelection.addTarget(self, action: #selector(selectReasonAction(_:)), for: .touchUpInside)
        cell.btnSelection.tag = indexPath.row
        if selectedReasonIndex == indexPath.row {
            cell.selectionImg.image = VDImageAsset.checkBoxOrange.asset
        } else {
            cell.selectionImg.image = VDImageAsset.unchecked.asset
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VDCancelReasonVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == VDColors.textColorGrey.color {
            textView.text = nil
            textView.textColor = VDColors.textColor.color
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        selectedReasonIndex = -1
        cancelTableView.reloadData()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Specify your reason"
            textView.textColor = VDColors.textColorGrey.color
        }
    }
}
