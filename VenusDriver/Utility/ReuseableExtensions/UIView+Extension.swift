//
//  UIView+Extension.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import  UIKit
// swiftlint:disable all
import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        // Set placeholder image if provided
        self.image = placeholder

        // Download the image
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let downloadedImage = UIImage(data: data)
            else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}

extension UIView {
    enum Border {
        case left
        case right
        case top
        case bottom
    }
    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    /// Returns the parent view controller ( if any ) of the view
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var safeAreaFrame: CGRect {
        return safeAreaLayoutGuide.layoutFrame
    }
    
    /// Adds the slope in view
    var addSlope:Void {
        
        // Make path to draw traingle
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        // Add path to the mask
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        
        self.layer.mask = mask
        
        // Adding shape to view's layer
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path.cgPath
        shape.fillColor = UIColor.gray.cgColor
        
        self.layer.insertSublayer(shape, at: 1)
    }
    
    /// Sets the corner radius of the view
    @IBInspectable var `cornerRadius`: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// Sets the border width of the view
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Sets the border color of the view
    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Sets the shadow color of the view
    @IBInspectable var shadowColor:UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.shadowColor = newValue!.cgColor
        }
    }
    
    /// Sets the shadow opacity of the view
    @IBInspectable var shadowOpacity:Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// Sets the shadow offset of the view
    @IBInspectable var shadowOffset:CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// Sets the shadow radius of the view
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    /// Adds constraints from a view to other view
//    func adjustConstraints(to view: UIView, attributes: (top: CGFloat, trailing: CGFloat, leading: CGFloat, bottom: CGFloat) = (0, 0, 0, 0)) -> [NSLayoutConstraint] {
//        return [
//            NSLayoutConstraint(
//                item: self, attribute: .top, relatedBy: .equal,
//                toItem: view, attribute: .top, multiplier: 1.0,
//                constant: attributes.top
//            ),
//            NSLayoutConstraint(
//                item: self, attribute: .trailing, relatedBy: .equal,
//                toItem: view, attribute: .trailing, multiplier: 1.0,
//                constant: attributes.trailing
//            ),
//            NSLayoutConstraint(
//                item: self, attribute: .leading, relatedBy: .equal,
//                toItem: view, attribute: .leading, multiplier: 1.0,
//                constant: attributes.leading
//            ),
//            NSLayoutConstraint(
//                item: self, attribute: .bottom, relatedBy: .equal,
//                toItem: view, attribute: .bottom, multiplier: 1.0,
//                constant: attributes.bottom
//            )
//        ]
//    }

    /// Sets the circle shadow in the view
    func setCircleShadow(shadowRadius: CGFloat = 2,
                         shadowOpacity: Float = 0.3,
                         shadowColor: CGColor = UIColor.gray.cgColor,
                         shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }

    /// Rounds the given corner based on the given radius
    func roundCorner(_ corner: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corner,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    /// Rounds all the corners of the view
    func roundCorners() {
        roundCorner(.allCorners, radius: self.bounds.width/2.0)
    }

    public func round() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = height/2
    }

    public func round(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
        self.layer.cornerRadius = radius
    }

    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func setUnderline(border: UIView.Border, weight: CGFloat, color: UIColor ) {

        let lineView = UIView()
        addSubview(lineView)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false

        switch border {

        case .left:
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true

        case .right:
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true

        case .top:
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true

        case .bottom:
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
        }
    }

    /// adds shadow in the view
func drawShadow(shadowColor:UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.798828125), shadowOpacity:Float = 0.14, shadowPath:UIBezierPath? = nil, shadowRadius:Float = 5, offset: CGSize = CGSize(width: -1, height: 1)) {

        var shdwpath = shadowPath
        if shadowPath == nil {
            shdwpath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor  = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath   = shdwpath!.cgPath
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = CGFloat(shadowRadius)
    }

func addShadowView(width: CGFloat = 2.0, height: CGFloat = 2.0, opacidade: Float = 1.0, maskToBounds: Bool = false, radius: CGFloat = 5, color: UIColor = .lightGray) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
    var globalPoint:CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame:CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    func clipToPolygon(corners: Int) {
        guard corners >= 3 else {
            return
        }
        let radius = min(self.frame.width/2.0,self.frame.height/2.0)
        let center = CGPoint(x:self.bounds.width/2.0,y:self.bounds.height/2.0)
        let path = UIBezierPath()
        path.lineWidth = 1
        for index in 0...corners {
            let rad = (Double.pi / Double(corners) ) * Double(index * 2 + 1)
            let drawPoint = CGPoint(x: center.x + radius * CGFloat(cos(rad)),
                                    y: center.y + radius * CGFloat(sin(rad)))
            if index == 0 {
                path.move(to: drawPoint)
            } else if index == corners {
                path.close()
            } else {
                path.addLine(to: drawPoint)
            }
        }
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = false
    }
    
    func getPixelColorAt(point: CGPoint) -> UIColor {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let color = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate()
        return color
    }
    
    func removeLayer(layerName: String) {
        for item in self.layer.sublayers ?? [] where item.name == layerName {
            item.removeFromSuperlayer()
        }
    }

}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
    
    func captureJPGScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImg = img?.jpegData(compressionQuality: 0.6) else {
            return nil
        }
        
        let image = UIImage(data: newImg)
        return image
    }
    
    func captureScreenshot(_ scale: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImg = img?.pngData() else {
            return nil
        }
        
        let image = UIImage(data: newImg)
        return image
    }
}

public extension UIView {

    enum SimpleAnimationEdge {
        case none
        case top
        case bottom
        case left
        case right
    }
    
    @discardableResult func fadeIn(duration: TimeInterval = 0.25,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
                self.alpha = 1
            }, completion: completion)
        return self
    }
    
    @discardableResult func fadeOut(duration: TimeInterval = 0.25,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.alpha = 0
            }, completion: completion)
        return self
    }
    
    @discardableResult func fadeColor(toColor: UIColor = UIColor.red,
                                      duration: TimeInterval = 0.25,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
                self.backgroundColor = toColor
            }, completion: completion)
        return self
    }
    
    @discardableResult func slideIn(from edge: SimpleAnimationEdge = .none,
                                    xValue: CGFloat = 0,
                                    yValue: CGFloat = 0,
                                    duration: TimeInterval = 0.4,
                                    delay: TimeInterval = 0,
                                    completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + xValue, y: offset.y + yValue)
        isHidden = false
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            }, completion: completion)
        return self
    }
    
    @discardableResult func slideOut(to edge: SimpleAnimationEdge = .none,
                                     xValue: CGFloat = 0,
                                     yValue: CGFloat = 0,
                                     duration: TimeInterval = 0.25,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let endTransform = CGAffineTransform(translationX: offset.x + xValue, y: offset.y + yValue)
        UIView.animate(
            withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.transform = endTransform
            }, completion: completion)
        return self
    }
    
    @discardableResult func bounceIn(from edge: SimpleAnimationEdge = .none,
                                     xValue: CGFloat = 0,
                                     yValue: CGFloat = 0,
                                     duration: TimeInterval = 0.5,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + xValue, y: offset.y + yValue)
        isHidden = false
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.58, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            }, completion: completion)
        return self
    }
    
    @discardableResult func bounceOut(to edge: SimpleAnimationEdge = .none,
                                      xValue: CGFloat = 0,
                                      yValue: CGFloat = 0,
                                      duration: TimeInterval = 0.35,
                                      delay: TimeInterval = 0,
                                      completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        let delta = CGPoint(x: offset.x + xValue, y: offset.y + yValue)
        let endTransform = CGAffineTransform(translationX: delta.x, y: delta.y)
        let prepareTransform = CGAffineTransform(translationX: -delta.x * 0.2, y: -delta.y * 0.2)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                    self.transform = endTransform
                }
            }, completion: completion)
        return self
    }
    
    @discardableResult func popIn(fromScale: CGFloat = 0.5,
                                  duration: TimeInterval = 0.5,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        isHidden = false
        alpha = 0
        transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            }, completion: completion)
        return self
    }
    
    @discardableResult func popOut(toScale: CGFloat = 0.5,
                                   duration: TimeInterval = 0.3,
                                   delay: TimeInterval = 0,
                                   completion: ((Bool) -> Void)? = nil) -> UIView {
        let endTransform = CGAffineTransform(scaleX: toScale, y: toScale)
        let prepareTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.transform = prepareTransform
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.transform = endTransform
                    self.alpha = 0
                }
            }, completion: completion)
        return self
    }
    
    @discardableResult func hop(toward edge: SimpleAnimationEdge = .none,
                                amount: CGFloat = 0.4,
                                duration: TimeInterval = 0.6,
                                delay: TimeInterval = 0,
                                completion: ((Bool) -> Void)? = nil) -> UIView {
        var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
        if edge == .none {
            ds = amount / 2
        } else if edge == .left || edge == .right {
            dx = (edge == .left ? -1: 1) * self.bounds.size.width * amount
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1: 1) * self.bounds.size.height * amount
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                    let trX = CGAffineTransform(translationX: dx, y: dy)
                    self.transform = trX.scaledBy(x: 1 + ds, y: 1 + ds)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
                    self.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 0.56, relativeDuration: 0.28) {
                    let trX = CGAffineTransform(translationX: dx * 0.5, y: dy * 0.5)
                    self.transform = trX.scaledBy(x: 1 + ds * 0.5, y: 1 + ds * 0.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.84, relativeDuration: 0.16) {
                    self.transform = .identity
                }
            }, completion: completion)
        return self
    }
    
    @discardableResult func shake(toward edge: SimpleAnimationEdge = .none,
                                  amount: CGFloat = 0.15,
                                  duration: TimeInterval = 0.6,
                                  delay: TimeInterval = 0,
                                  completion: ((Bool) -> Void)? = nil) -> UIView {
        let steps = 8
        let timeStep = 1.0 / Double(steps)
        var dx: CGFloat, dy: CGFloat
        if edge == .left || edge == .right {
            dx = (edge == .left ? -1: 1) * self.bounds.size.width * amount
            dy = 0
        } else {
            dx = 0
            dy = (edge == .top ? -1: 1) * self.bounds.size.height * amount
        }
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
                var start = 0.0
                for index in 0..<(steps - 1) {
                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                        self.transform = CGAffineTransform(translationX: dx, y: dy)
                    }
                    if edge == .none && index % 2 == 0 {
                        swap(&dx, &dy)  // Change direction
                        dy *= -1
                    }
                    dx *= -0.85
                    dy *= -0.85
                    start += timeStep
                }
                UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
                    self.transform = .identity
                }
            }, completion: completion)
        return self
    }
    
    private func offsetFor(edge: SimpleAnimationEdge) -> CGPoint {
        if let parentSize = self.superview?.frame.size {
            switch edge {
            case .none: return CGPoint.zero
            case .top: return CGPoint(x: 0, y: -frame.maxY)
            case .bottom: return CGPoint(x: 0, y: parentSize.height - frame.minY)
            case .left: return CGPoint(x: -frame.maxX, y: 0)
            case .right: return CGPoint(x: parentSize.width - frame.minX, y: 0)
            }
        }
        return .zero
    }
    
    func shakeView() {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: point)]
        
        keyFrame.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        keyFrame.duration = 0.7
        self.layer.position = point
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}

extension UIScrollView {
    
    func scrollToBottom(_ animated: Bool = true) {
        if (contentSize.height + contentInset.bottom) < bounds.height {
            return
        }
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if !bottomOffset.y.isZero {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T
    }
    
    var safeAreaBottom: CGFloat {
        if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
        }
        return 0
    }
    
    var safeAreaTop: CGFloat {
        if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
        }
        return 0
    }
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

extension UIView {
    private func pointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func pointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pointDistanceSquared(from: from, to: to))
    }
}
// swiftlint:enable all
extension String{
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
