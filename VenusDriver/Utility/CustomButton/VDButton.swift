//
//  VDButton.swift
//  VenusDriver
//
//  Created by Amit on 21/07/23.
//

import UIKit

@IBDesignable
class VDButton: UIButton {

    // Define the colors for the gradient
    @IBInspectable var startColor: UIColor = VDColors.buttonSelectedOrange.color {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = VDColors.buttonGreen.color {
        didSet {
            updateGradient()
        }
    }

    // Create gradient layer
    let gradientLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        // Set the gradient frame
        gradientLayer.frame = rect

        // Set the colors
        gradientLayer.colors = [startColor.cgColor]
        // Gradient is linear from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        // Add gradient layer into the button
        if whiteLabelProperties.appButtonGradient {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
        // Round the button corners
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }

    func updateGradient() {
        if whiteLabelProperties.appButtonGradient {
            gradientLayer.colors = [startColor.cgColor]
        } else {
            self.backgroundColor = startColor
        }
        gradientLayer.frame = bounds
//        if let globalProperties = getGlobalPropertyList() {
//            if (globalProperties["appButtonGradient"] as! Bool) {
//                gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//            } else {
//                gradientLayer.colors = [startColor.cgColor, startColor.cgColor]
//            }
//        } else {
//            gradientLayer.colors = [startColor.cgColor, startColor.cgColor]
//        }
    }
}
