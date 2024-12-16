//
//  VDUploadDocumentViewModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

class VDUploadDocumentViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateDocumentDetail : ((DocumentDetails) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var docuemntdetail : DocumentDetails! {
        didSet {
            self.updateDocumentDetail(docuemntdetail)
        }
    }

    override init() {
        super.init()
    }
}



//MARK: LOGIN API'S
extension VDUploadDocumentViewModel {

    func uploadDocument(_ attributes : [String : Any] , _ image : UIImage) {
        let image = ["image" : image]
        WebServices.uploadDocumentApi(parameters: attributes, image: image) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(true)
                SKToast.show(withMessage: "Document uploaded successfully.")
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
