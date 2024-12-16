//
//  ReceiverTblCell.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 15/07/24.
//

import UIKit

class ReceiverTblCell: UITableViewCell {

    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReceiver: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
