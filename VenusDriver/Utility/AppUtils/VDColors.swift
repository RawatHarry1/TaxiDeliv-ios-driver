//
//  VDColors.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VDColors: String, CaseIterable {

    case textColor
    case textColorGrey
    case textColorWhite
    case buttonSelectedOrange
    case buttonBorder
    case buttonGreen
    case textFieldBorder
    case textColorGreen
    case textColorRed

    var color: UIColor {
        return UIColor(named: rawValue)!
    }
}
