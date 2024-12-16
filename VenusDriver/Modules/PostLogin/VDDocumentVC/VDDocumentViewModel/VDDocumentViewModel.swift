//
//  VDDocumentViewModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

class VDDocumentViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateDocumentList : ((DocumentList) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var docuemntList : DocumentList! {
        didSet {
            self.updateDocumentList(docuemntList)
        }
    }

    override init() {
        super.init()
    }
}



//MARK: LOGIN API'S
extension VDDocumentViewModel {
    func fetchDocumentsList() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.getDocumentList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? DocumentList else { return }
                self?.docuemntList = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
