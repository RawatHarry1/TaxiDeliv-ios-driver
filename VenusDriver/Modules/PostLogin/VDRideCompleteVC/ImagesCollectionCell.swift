//
//  ImagesCollectionCell.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/11/24.
//

import UIKit

class ImagesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?
    
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.didPressDelete!()
    }
    
}
class ImagesCollectionCell2: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?
    
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.didPressDelete!()
    }
    
}
