//
//  CardsTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/08/24.
//

import UIKit

class CardsTblCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var imgViewRadio: UIImageView!
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.setTitle("", for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
