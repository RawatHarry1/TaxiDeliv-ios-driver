//
//  VDIntroCollectionCell.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VDIntroCollectionCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak private(set) var imgView: UIImageView!
    @IBOutlet weak private(set) var lblTitle: UILabel!
    @IBOutlet weak private(set) var lblSubTitle: UILabel!

    // MARK: - Variables
    var images = [VDImageAsset.introFirst.asset, VDImageAsset.introSecond.asset, VDImageAsset.introThird.asset ]
    var titles = ["Join The Green Team", "Available Everywhere", "Highest Earnings"]
    var firstSubtitle = "Volt is exclusively for drivers with fully electric vehicles."
    var secondSubtitle = "Set your own hours and areas where you would like to drive."
    var thirdSubtitle = "Earn 100% of the passenger fare. Pay a small flat fee per trip."
    var subtitle = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        subtitle = [firstSubtitle, secondSubtitle, thirdSubtitle]
    }

    func updateUIWithData(index: Int) {
        imgView.image = images[index]
        lblTitle.text = titles[index]
        lblSubTitle.text = subtitle[index]
    }
}
