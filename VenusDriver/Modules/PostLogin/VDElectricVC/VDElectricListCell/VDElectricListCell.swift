//
//  VDElectricListCell.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import UIKit

class VDElectricListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpVehicleTypeUI(_ type: VehiclesType) {
        subtitleLbl.isHidden = true
        titleLabel.text = type.vehicle_type_name
    }

    func setColorUI(_ color: VehicleColors) {
        subtitleLbl.isHidden = true
        titleLabel.text = color.value
    }

    func setModelUI(_ model: VehiclesModel) {
        subtitleLbl.isHidden = false
        titleLabel.text = model.brand
        subtitleLbl.text = model.model_name
    }

    func setUpdateYearUI(_ year: String) {
        subtitleLbl.isHidden = true
        titleLabel.text = year
    }
    
    func setCityListUI(_ city: City_list) {
        subtitleLbl.isHidden = true
        titleLabel.text = city.city_name ?? ""
    }
}
