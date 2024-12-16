//
//  SIIntroCollectionCell.swift
//  VenusDriver
//
//  Created by Amit on 22/07/23.
//

import UIKit

class SIIntroCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var introImg: UIImageView!

    var images = [VDImageAsset.introSalone1.asset, VDImageAsset.introSalone2.asset, VDImageAsset.introSalone3.asset, VDImageAsset.introSalone4.asset ]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUIWithData(index: Int) {
        introImg.image = images[index]
    }
}
