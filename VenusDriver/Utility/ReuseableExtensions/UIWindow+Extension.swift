//
//  UIWindow+Extension.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

extension UIWindow {

    var currentViewController: UIViewController? {
        guard let rootViewController = self.rootViewController else { return nil}
        return topViewController(for: rootViewController)
    }

    // swiftlint:disable force_cast
    private func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        switch rootViewController {
        case is UINavigationController:
            let navigationController = rootViewController as! UINavigationController
            return topViewController(for: navigationController.viewControllers.last)
        case is UITabBarController:
            let tabBarController = rootViewController as! UITabBarController
            return topViewController(for: tabBarController.selectedViewController)
        default:
            guard let presentedViewController = rootViewController.presentedViewController else {
                return rootViewController
            }
            return topViewController(for: presentedViewController)
        }
    }
    // swiftlint:enable force_cast

    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
