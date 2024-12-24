//
//  VDSideMenuCell.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDSideMenuCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
    
    var titles = ["Home", "Account", "Earnings", "Wallet","Cards", "Bookings", "Documents", "Ratings", "Notifications", "About Us", "Vehicle List","Delete Account", "Log Out"]
    var images = [UIImage?]()

    override func awakeFromNib() {
        super.awakeFromNib()
        images = [VDImageAsset.home.asset, VDImageAsset.account.asset, VDImageAsset.earnings.asset, VDImageAsset.wallet.asset,VDImageAsset.creditCard.asset, VDImageAsset.bookings.asset, VDImageAsset.documents.asset]
        images += [VDImageAsset.ratings.asset, VDImageAsset.notifications.asset, VDImageAsset.aboutUs.asset, VDImageAsset.document.asset, VDImageAsset.delete.asset,VDImageAsset.logout.asset]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpUI(_ index: Int) {
        alertIcon.isHidden = true
        iconImg.image = images[index]
        iconImg.image = iconImg.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconImg.tintColor = VDColors.buttonSelectedOrange.color
        titleLabel.text = titles[index]
        
        guard let userData = UserModel.currentUser.login else {return}
        guard let docStatus = userData.driver_document_status?.requiredDocsStatus else {return}
        titleLabel.textColor = VDColors.textColor.color
        if index == 6 {
            if (docStatus == DocumentStatus.rejected.rawValue || docStatus == DocumentStatus.expired.rawValue) {
                titleLabel.textColor = VDColors.textColorRed.color
                alertIcon.isHidden = false
            } else {
                titleLabel.textColor = VDColors.textColor.color
                alertIcon.isHidden = true
            }
        }
    }

}
