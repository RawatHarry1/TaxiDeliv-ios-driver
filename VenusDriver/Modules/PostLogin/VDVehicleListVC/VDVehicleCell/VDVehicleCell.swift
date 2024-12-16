//
//  VDVehicleCell.swift
//  VenusDriver
//
//  Created by Amit on 21/06/23.
//

import UIKit

class VDVehicleCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var seatsLbl: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var permitLbl: UILabel!
    @IBOutlet weak var validUptoLbl: UILabel!
    @IBOutlet weak var vehicleNumberLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(_ carDetails: VehiclesList) {
        seatsLbl.text = "\(carDetails.no_of_seats ?? 0) Seater"
        nameLbl.text = carDetails.model_name
        if let urlStr = carDetails.make_image {
            self.carImg.setImage(withUrl: urlStr) { status, image in
                if status {
                    if let img = image {
                        self.carImg.image = img
                    }
                }
            }
        }
//        validUptoLbl.text = carDetails.
        permitLbl.text = carDetails.color ?? "-"
        vehicleNumberLbl.text = carDetails.vehicle_no ?? "-"
        validUptoLbl.text = carDetails.vehicle_type_name ?? "-"
    }
    
}
