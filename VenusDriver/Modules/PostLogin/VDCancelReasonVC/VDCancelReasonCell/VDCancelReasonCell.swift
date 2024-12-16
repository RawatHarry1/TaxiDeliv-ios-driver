//
//  VCCancelReasonCell.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VDCancelReasonCell: UITableViewCell {
    
    @IBOutlet weak var selectionImg: UIImageView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var reasonLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellUI(index: Int) {
        if let reasons = UserModel.currentUser.login?.cancellation_reasons {
            reasonLbl.text = reasons[index]
        }
    }
}
