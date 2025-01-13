//
//  UploadPhotoViewModal.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 13/11/24.
//

import UIKit
import SDWebImage
struct PackageStatusModal: Codable{
    var flag: Int?
    var message: String?
    var deliveryRestriction : String?
    var data: MessageData?
    var can_end : Int?
}

struct MessageData: Codable{
    var can_start: Int?
    var can_end: Int?
}

class UploadPhotoViewModal {

    var objUplodPhotoModal : UplodPhotoModal?
    var objPackageStatusModal : PackageStatusModal?
    var imageUrlArr = [String]()
    func uploadPhoto(_ attributes : [String : Any] , _ image : UIImage ,completion:@escaping() -> Void) {
        let image = ["image" : image]
        WebServices.uploadPackageImageApi(parameters: attributes, image: image) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? UplodPhotoModal else {return}
                
                self?.objUplodPhotoModal = card
                self?.imageUrlArr.append(card.data?.file_path ?? "")
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func deliveriPackageApi(tripID: String,driverID:String,packageId:String,images:[String],reason:String,AcceptTrip: Bool,comerFromMarkArive:Bool,completion:@escaping() -> Void) {
        
        var params : JSONDictionary  {
            if comerFromMarkArive == true{
                var attribute = [String : Any]()
                attribute["trip_id"] = tripID
                attribute["driver_id"] = driverID
                attribute["package_id"] = packageId
                attribute["package_images"] = images
                attribute["is_for_pickup"] = 1
               
                if AcceptTrip == false{
                    attribute["cancelltion_reason"] = reason
                }
                return attribute
            }else{
                var attribute = [String : Any]()
                attribute["trip_id"] = tripID
                attribute["driver_id"] = driverID
                attribute["package_id"] = packageId
                attribute["package_images"] = images
                attribute["is_for_end"] = 1
                
                if let locationCreds = LocationTracker.shared.lastLocation {
                    attribute["current_latitude"] = locationCreds.coordinate.latitude
                    attribute["current_longitude"] = locationCreds.coordinate.longitude
                }
                attribute["package_delivery_restriction_enabled"] = ClientModel.currentClientData.city_list?[0].package_delivery_restriction_enabled ?? 0
                attribute["maximum_distance"] = ClientModel.currentClientData.city_list?[0].maximum_distance ?? ""
                attribute["drop_latitude"] = sharedAppDelegate.notficationDetails?.drop_latitude
                attribute["drop_longitude"] = sharedAppDelegate.notficationDetails?.drop_longitude
                attribute["city_id"] = ClientModel.currentClientData.city_list?[0].city_id ?? ""
                print(attribute)

                if AcceptTrip == false{
                    attribute["cancelltion_reason"] = reason
                }
                return attribute
            }
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
