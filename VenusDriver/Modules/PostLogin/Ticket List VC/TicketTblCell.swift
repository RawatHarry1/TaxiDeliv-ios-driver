//
//  TicketTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 10/12/24.
//

import UIKit

class TicketTblCell: UITableViewCell {
    @IBOutlet weak var ticketId: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
