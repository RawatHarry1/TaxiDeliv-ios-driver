//
//  VDBookingCell.swift
//  VenusDriver
//
//  Created by Amit on 19/06/23.
//

import UIKit

class VDBookingCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var rideImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(_ model: BookingHistoryModel) {
        nameLbl.text = model.customer_name ?? ""
        if let currency = UserModel.currentUser.login?.currency_symbol {
            fareLbl.text = currency + " " + (model.total_fare ?? 0.0).toString
        } else {
            fareLbl.text = "$ " + (model.total_fare ?? 0.0).toString
        }
        dateLbl.text  =  ConvertDateFormater(date: model.created_at ?? "")
        self.rideImgView.setImage(withUrl: model.tracking_image ?? "") { status, image in}
    }
}

extension Double {
    var toString:String {
        return String(format:"%.2f",self)
    }
}
