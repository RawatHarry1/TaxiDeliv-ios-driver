//
//  VDLGMainVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit
import LGSideMenuController

class VDLGMainVC: LGSideMenuController {

    private struct Keys {
        static var sideMenuController = "sideMenuController"
    }

    static func getSideMenuController(from viewController: UIViewController) -> LGSideMenuController? {
        return objc_getAssociatedObject(viewController, &Keys.sideMenuController) as? LGSideMenuController
    }

    static func create() -> UIViewController {
        let obj = VDLGMainVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let navVC = UINavigationController.init(rootViewController: VDHomeVC.create())
        navVC.isNavigationBarHidden = true
        self.rootViewController = navVC
        self.leftViewController = VDSideMenuVC.create()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: .openSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSideMenu), name: .closeSideMenu, object: nil)
        self.leftViewPresentationStyle = .scaleFromBig
        self.leftViewWidth = 250.0
        self.isLeftViewSwipeGestureEnabled = false
        self.isRightViewSwipeGestureEnabled = false
    }

    @objc func showSideMenu() {
        self.showLeftView()
        (self.leftViewController as! VDSideMenuVC).reloadData()
    }

    @objc private func hideSideMenu() {
        self.hideLeftView()
    }
}


extension UIViewController {

    /// If the view controller or one of its ancestors is a child of a LGSideMenuController, this property contains the owning LGSideMenuController.
    /// This property is nil if the view controller is not embedded inside a LGSideMenuController.
    weak open var sideMenuController: LGSideMenuController? {
        if let controller = self as? LGSideMenuController {
            return controller
        }
        if let controller = VDLGMainVC.getSideMenuController(from: self) {
            return controller
        }
        if let controller = self.parent?.sideMenuController {
            return controller
        }
        return nil
    }

}
