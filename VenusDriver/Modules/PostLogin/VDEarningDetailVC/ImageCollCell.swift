//
//  ImageCollCell.swift
//  VenusDriver
//
//  Created by Paramveer Singh on 12/01/25.
//

import UIKit

class ImageCollCell: UITableViewCell {

    @IBOutlet var imgMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMain.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
