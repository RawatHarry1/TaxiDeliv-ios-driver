//
//  ImageCollCellMain.swift
//  VenusDriver
//
//  Created by Paramveer Singh on 12/01/25.
//

import UIKit

class ImageCollCellMain: UICollectionViewCell {

    @IBOutlet var imgMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMain.layer.cornerRadius = 8

        // Initialization code
    }

}
