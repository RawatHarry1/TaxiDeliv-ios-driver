//
//  VDDocumentVerificationVC.swift
//  VenusDriver
//
//  Created by Amit on 21/08/23.
//

import UIKit

class VDDocumentVerificationVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> VDDocumentVerificationVC {
        let obj = VDDocumentVerificationVC.instantiate(fromAppStoryboard: .documents)
        return obj
    }

    override func initialSetup() {

    }
}
