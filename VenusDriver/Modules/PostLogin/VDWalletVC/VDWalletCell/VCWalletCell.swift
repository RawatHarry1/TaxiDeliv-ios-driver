//
//  VDWalletCell.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VDWalletCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var lblAmountStatus: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpUI(_ transaction: Transactions) {
        var currency = ""
        if let mycurrency = UserModel.currentUser.login?.currency_symbol {
            currency = mycurrency
        }
        lblAmountStatus.text = transaction.txn_type
        let transactionAmt: Double = transaction.amount ?? 0.0
        ((transaction.txn_type ?? "Credited") == "Credited") ? (amountLbl.text = "+\(currency)\(transactionAmt.toString)") : (amountLbl.text = "-\(currency)\(transaction.amount ?? 0)")
        amountLbl.textColor = ((transaction.txn_type ?? "Credited") != "Credited") ? VDColors.textColorRed.color : VDColors.textColorGreen.color
        timeLbl.text = getTimeFromUTCDate(date: transaction.logged_on ?? "")//transaction.txn_time
        idLbl.text = "\(transaction.reference_id ?? 0)"
        dateLbl.text = getDateFromUTCDate(date: transaction.logged_on ?? "")//transaction.txn_date
    }
    
}
