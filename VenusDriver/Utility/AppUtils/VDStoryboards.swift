//
//  VDStoryboards.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VDStoryboard: String {

    case main = "Main"
    case preLogin = "Prelogin"
    case postLogin = "PostLogin"
    case documents = "Documents"
    case ratings = "Ratings"
    case wallet = "Wallet"

    //Salone Ride
    case saloneMain = "SaloneMain"

}

extension VDStoryboard {

    var shared: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    /**
     - parameters:
     - viewControllerClass: The view controller to instantiate
     - function: Function that calls this method, only for debugging purpose
     - line: Line number, only for debugging purpose
     - file: File name, only for debugging purpose
     */
    func viewController<T: UIViewController>(_ viewControllerClass: T.Type,function: String = #function,line: Int = #line,file: String = #file) -> T {

        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let scene = shared.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile: \(file) \nLine Number: \(line) \nFunction: \(function)")
        }

        return scene
    }

    var initialViewController: UIViewController? {
        return shared.instantiateInitialViewController()
    }
}

extension UIViewController {

    /**
     - parameters:
     - appStoryboard: The storyboard from view controller is to be referenced

     Not using static as it wont be possible to override to provide custom storyboardID then
     */
    class func instantiate(fromAppStoryboard appStoryboard: VDStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }

    class var storyboardID: String {
        return "\(self)"
    }
}
