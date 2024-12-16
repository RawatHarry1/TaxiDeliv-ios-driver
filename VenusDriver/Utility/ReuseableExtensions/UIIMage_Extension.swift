//
//  UIIMage_Extension.swift
//  VenusDriver
//
//  Created by Amit on 02/08/23.
//

import Foundation
import Kingfisher

extension UIImage {

    func resizeImage(targetSize: CGSize) -> UIImage {

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> (img : UIImage, height : CGFloat) {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (img : newImage!, height : newHeight)
    }
}

extension UIImageView {

    func setImage(_ url: String, showIndicator: Bool = false) {
        guard let url = URL(string: url) else {
            return
        }
        if showIndicator {
            kf.indicatorType = .activity
            (kf.indicator?.view as? UIActivityIndicatorView)?.color = VDColors.buttonSelectedOrange.color
            (kf.indicator?.view as? UIActivityIndicatorView)?.style = .medium
        }
        kf.setImage(with: url, placeholder: nil)
    }

    func setImage(withUrl url: String, placeholderImage: UIImage? = nil, showIndicator: Bool = false, completion: ImageCompletionHandlerWithStatus = nil) {
        guard let url = URL(string: url) else {
            image = placeholderImage
            completion?(false, nil)
            return
        }
        if showIndicator {
            kf.indicatorType = .activity
            (kf.indicator?.view as? UIActivityIndicatorView)?.color = VDColors.buttonSelectedOrange.color
        }
        kf.setImage(with: url, placeholder: placeholderImage, options:.none, completionHandler: { result in
            switch result {
            case .success(let data):
                completion?(true, data.image)
            case .failure(let error):
                printDebug(error.localizedDescription)
                completion?(false, nil)
            }
        })
    }

    func setImage(_ url: String, placeHolder: UIImage?) {
        guard let url = URL(string: url) else {
            image = placeHolder
            return
        }
        kf.setImage(with: url, placeholder: placeHolder)
    }

    func setGIFImage(_ url: String, placeholder: UIImage?, completion: (() -> Void)?) {
        guard let url = URL(string: url) else {
            image = placeholder
            return
        }
        kf.setImage(with: url, placeholder: placeholder, options: .none, completionHandler: { result in
            switch result {
            case .success(let result):
                let image = result.image
                self.animationImages = image.images
                self.animationDuration = image.duration
                self.animationRepeatCount = 2
                self.image = image.images?.last
                self.startAnimating()
                completion?()
            case .failure(let error):
                printDebug(error)
            }
        })
    }

//    func getImageFrom(urlStr: String, completion: ((_ downloadedImage: UIImage?) -> Void)?) {
//        guard let url = URL(string: urlStr) else { return }
//        let resource = ImageResource(downloadURL: url, cacheKey: urlStr)
//        kf.setImage(with: resource, placeholder: nil, completionHandler: { (result) in
//            switch result {
//            case .success(let data):
//                completion?(data.image)
//            case .failure(let error):
//                printDebug(error)
//                completion?(nil)
//            }
//        })
//    }
}
