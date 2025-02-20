//
//  QuickMenuCollectionCell.swift
//  VenusDriver
//
//  Created by TechBuilder on 19/02/25.
//

import UIKit

class QuickMenuCollectionCell: UICollectionViewCell {
    @IBOutlet weak var btnEarnig: UIButton!
    @IBOutlet weak var lblRides: UILabel!
    
    @IBOutlet weak var btnSeeEarning: UIButton!
    @IBOutlet weak var heightTripId: NSLayoutConstraint!
    @IBOutlet weak var tripID: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblEarningActivity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
