//
//  VDNotificationCell.swift
//  VenusDriver
//
//  Created by Amit on 14/06/23.
//

import UIKit

class VDNotificationCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(_ notification: NotificationDetails) {
        titleLbl.text = notification.title ?? ""
    }
    
}
