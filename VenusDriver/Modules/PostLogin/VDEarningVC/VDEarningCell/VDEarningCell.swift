//
//  VDEarningCell.swift
//  VenusDriver
//
//  Created by Amit on 19/06/23.
//

import UIKit

class VDEarningCell: UITableViewCell {

    //MARK: - Outlets

    @IBOutlet weak var customerProfileImg: UIImageView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellUI(_ ride: VDRides) {

        if let urlStr = ride.customerImage {
            self.customerProfileImg.setImage(withUrl: urlStr, placeholderImage:VDImageAsset.profileImgDummy.asset, showIndicator: true)
        }

        customerNameLbl.text = ride.customerName
        if let id = ride.engagement_id {
            idLbl.text = "#" + "\(id)"
        } else {
            idLbl.text = "#"
        }
        if let currency = UserModel.currentUser.login?.currency_symbol {
            amountLbl.text = currency + " " + (ride.totalEarnings?.toString ?? "")
        } else {
            amountLbl.text = "$ " + (ride.totalEarnings?.toString ?? "")
        }
    }
}
