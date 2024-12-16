//
//  VDDocumentCell.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDDocumentCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(_ index: Int) {
        if index == 0 {
            docImage.backgroundColor = .clear
            docImage.image = VDImageAsset.dummyDoc.asset
            docImage.layer.borderWidth = 0
            actionBtn.setImage(VDImageAsset.removeDoc.asset, for: .normal)
        } else if index == 1 {
            docImage.backgroundColor = VDColors.buttonSelectedOrange.color
            docImage.image = nil
            docImage.layer.borderWidth = 0
            actionBtn.setImage(VDImageAsset.documentAdd.asset, for: .normal)
        } else if index == 2 {
            docImage.backgroundColor = .clear
            docImage.image = nil
            docImage.layer.borderWidth = 1
            docImage.layer.borderColor = VDColors.buttonBorder.color.cgColor
            actionBtn.setImage(VDImageAsset.documentAdd.asset, for: .normal)
        }
    }
}
