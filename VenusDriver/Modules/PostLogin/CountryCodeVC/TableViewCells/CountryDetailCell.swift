//
//  CountryDetailCell.swift
//  LiveChat
//
//  Created by Amit on 11/03/22.
//

import UIKit

class CountryDetailCell: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    //MARK: Outlets
    @IBOutlet weak var lbl_flag: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ country_detail: Country_Detail){
        lbl_flag.text = country_detail.flag
        lbl_name.text = country_detail.name
        
        
    }
    
}
