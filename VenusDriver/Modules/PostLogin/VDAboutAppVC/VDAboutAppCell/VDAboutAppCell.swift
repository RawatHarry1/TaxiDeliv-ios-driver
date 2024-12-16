//
//  VCAboutAppCell.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit

class VDAboutAppCell: UITableViewCell {

    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!

    var images = [VDImageAsset.rateUs.asset, VDImageAsset.likeus.asset, VDImageAsset.legal.asset, VDImageAsset.settingsAboutApp.asset, VDImageAsset.privacyPolicy.asset, VDImageAsset.emailAboutUs.asset]
    var titles = ["Rate us on App Store" ,
                  "Like us on Facebook" ,
                  "Legal" ,
                  "Who are we?" ,
                  "Privacy Policy" ,
                  "Email Support"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(_ index : Int) {
        titleImg.image = images[index]
        titleLbl.text = titles[index]
    }
    
}
