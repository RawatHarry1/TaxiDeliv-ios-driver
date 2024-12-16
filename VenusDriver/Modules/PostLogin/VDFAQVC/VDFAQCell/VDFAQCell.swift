//
//  VCFAQCell.swift
//  VenusCustomer
//
//  Created by Amit on 07/07/23.
//

import UIKit

class VDFAQCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnSelection: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpUI(_ value: Bool) {
        descLabel.isHidden = value

    }
}
