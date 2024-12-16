//
//  SkyfieldTF.swift
//  VenusDriver
//
//  Created by Amit on 09/06/23.
//

import Foundation
import SkyFloatingLabelTextField

class SkyfieldTF: SkyFloatingLabelTextField {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        uiChanges()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiChanges()
    }

    func uiChanges() {
        self.titleColor = .clear
        self.textColor = VDColors.textColor.color
        self.selectedTitleColor = .clear
        self.placeholderColor = VDColors.textColorGrey.color
//        self.lineColor = VDColors.textColor.color
        self.tintColor = VDColors.buttonSelectedOrange.color
        self.selectedLineHeight = 1.0
        self.selectedLineColor = VDColors.textColor.color
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: titleHeight(),
            width: bounds.size.width,
            height: (bounds.size.height - titleHeight() - selectedLineHeight)
        )
        return rect
    }
}

class SkyfieldPhoneTF: SkyFloatingLabelTextField {

    var leftPadding: CGFloat = 0

    override public init(frame: CGRect) {
        super.init(frame: frame)
        uiChanges()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiChanges()
    }

    func uiChanges() {
        self.titleColor = .clear
        self.textColor = VDColors.textColor.color
        self.selectedTitleColor = .clear
        self.placeholderColor = VDColors.textColorGrey.color
//        self.lineColor = VDColors.textColor.color
        self.tintColor = VDColors.buttonSelectedOrange.color
        self.selectedLineHeight = 1.0
        self.selectedLineColor = VDColors.textColor.color
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width,
            height: (bounds.size.height - titleHeight() - selectedLineHeight)
        )
        return rect
    }

    func addLeftViewPadding(_ padding: CGFloat) {
        let frameRect = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        let leftViewImage =  UIView(frame: frameRect)
        leftViewImage.backgroundColor = .clear
        self.leftViewMode = .always
        self.leftView = leftViewImage
    }
}

