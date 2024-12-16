//
//  VDFonts.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VDFonts: String {

    // SFUIText Font
    case sfuitextMedium = "SFUIText-Medium"
    case sfuitextRegular = "SFUIText-Regular"
    case sfuitextHeavy = "SFUIText-Heavy"
    case sfuitextBold = "SFUIText-Bold"
    case sfuitextLight = "SFUIText-Light"
    case sfuitextSemibold = "SFUIText-Semibold"
    case sfuitextLightItalic = "SFUIText-LightItalic"
    case sfuitextBoldItalic = "SFUIText-BoldItalic"
    case sfuitextMediumItalic = "SFUIText-MediumItalic"
    case sfuitextSemiboldItalic = "SFUIText-SemiboldItalic"
    case sfuitextHeavyItalic = "SFUIText-HeavyItalic"
    case sfuitextRegularItalic = "SFUIText-RegularItalic"

    // Inter Font
    case  proximaAltThin = "Proxima Nova Alt Thin"
    case  proximaAltBold = "Proxima Nova Alt Bold"
    case  proximaExtrabold = "Proxima Nova Extrabold"
    case  proximaAltLight = "Proxima Nova Alt Light"
    case  proximaBlack = "Proxima Nova Black"
    case  proximaBold = "Proxima Nova Bold"
    case  proximaRegular = "ProximaNova-Regular"
    case  proximaThin = "Proxima Nova Thin"

}

extension VDFonts {

    func withSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
}
