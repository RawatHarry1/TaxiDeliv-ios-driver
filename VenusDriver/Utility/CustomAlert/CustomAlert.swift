//
//  CustomAlert.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation
import UIKit


let errorTitle = "error"
var OAuth_Token = ""

protocol OurErrorProtocol: LocalizedError {

    var title: String? { get }
    var code: Int { get }
}
struct CustomError: OurErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? errorTitle
        self._description = description
        self.code = code
    }
}


class CustomAlertView {

   class func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], completion:((Bool,Int)->Void)?) -> Void {

       let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
       for (index,title) in buttons.enumerated() {
           let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
               completion?(true,index)
           }
           alertController.addAction(action)
       }
       onVc.present(alertController, animated: true, completion: nil)
   }

}
