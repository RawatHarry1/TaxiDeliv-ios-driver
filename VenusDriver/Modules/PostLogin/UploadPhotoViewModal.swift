//
//  UploadPhotoViewModal.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 13/11/24.
//

import UIKit

struct PackageStatusModal: Codable{
    var flag: Int?
    var message: String?
    var data: MessageData?
    
}

struct MessageData: Codable{
    var can_start: Int?
    var can_end: Int?
}

class UploadPhotoViewModal {

    var objUplodPhotoModal : UplodPhotoModal?
    var objPackageStatusModal : PackageStatusModal?
    
    func uploadPhoto(_ attributes : [String : Any] , _ image : UIImage ,completion:@escaping() -> Void) {
        let image = ["image" : image]
        WebServices.uploadPackageImageApi(parameters: attributes, image: image) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? UplodPhotoModal else {return}

                self?.objUplodPhotoModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func deliveriPackageApi(tripID: String,driverID:String,packageId:String,images:[String],reason:String,AcceptTrip: Bool,comerFromMarkArive:Bool,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["trip_id"] = tripID
            attribute["driver_id"] = driverID
            attribute["package_id"] = packageId
            attribute["package_images"] = images
            
            if comerFromMarkArive == true{
                attribute["is_for_pickup"] = 1
            }else{
                attribute["is_for_end"] = 1
            }
           
            
            if AcceptTrip == false{
                attribute["cancelltion_reason"] = reason
            }
            
            return attribute
        }
        WebServices.uploadPackageStatus(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? PackageStatusModal else {return}
                self?.objPackageStatusModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
