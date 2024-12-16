//
//  VDTextField.swift
//  VenusDriver
//
//  Created by Amit on 05/07/23.
//

import Foundation
import UIKit

class VDTextField: UITextField {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        uiChanges()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiChanges()
    }

    func uiChanges() {
        self.tintColor = VDColors.buttonSelectedOrange.color
        self.borderWidth = 1
        self.borderColor = VDColors.textFieldBorder.color
    }

    func roundCornerTF() {
        self.layer.cornerRadius = self.bounds.height/2
    }

    func addLeftView(_ img: UIImage?) {
        guard let image = img else { return }
        let frameRect = CGRect(x: 0, y: 0, width: 50, height: self.frame.height)
        let leftViewImage =  UIView(frame: frameRect)
        let imageView = UIImageView(frame: CGRect(x: 16, y: 0, width: 24, height: self.frame.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        leftViewImage.addSubview(imageView)
        self.leftViewMode = .always
        self.leftView = leftViewImage
    }

    func addLeftViewPadding(_ padding: CGFloat, _ round: Bool = true) {
        let frameRect = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        let leftViewImage =  UIView(frame: frameRect)
        leftViewImage.backgroundColor = .clear
        self.leftViewMode = .always
        self.leftView = leftViewImage
        if round { roundCornerTF() }
    }
}
