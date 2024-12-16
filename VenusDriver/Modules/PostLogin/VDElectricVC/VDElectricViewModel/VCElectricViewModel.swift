//
//  VCElectricViewModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

class VDElectricViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateDocumentList : ((VehicleFeatures) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var vehicleFeatures : VehicleFeatures! {
        didSet {
            self.updateDocumentList(vehicleFeatures)
        }
    }

    override init() {
        super.init()
    }
}



//MARK: LOGIN API'S
extension VDElectricViewModel {

    func validateAddVehicleDetails(_ vehicleYear: String, _ vehicleNo: String, _ vehicleMakeID: Int? , _ colorID: Int?, _ cityID: Int, vehicleType: String,request_ride_type:Int){
        if vehicleType == "" {
            error = CustomError(title: "", description: Const_Str.emptyVehicleType, code: 0)
            return
        }
        if vehicleMakeID == nil {
            error = CustomError(title: "", description: Const_Str.emptyVehicleModel, code: 0)
            return
        } else if colorID == nil {
            error = CustomError(title: "", description: Const_Str.emptyVehicleColor, code: 0)
            return
        } else if vehicleYear == "" {
            error = CustomError(title: "", description: Const_Str.emptyVehicleMake, code: 0)
            return
        } else if vehicleNo == "" {
            error = CustomError(title: "", description: Const_Str.emptylicenceNumber, code: 0)
            return
        } else {
            var attributes = [String:Any]()
            attributes["vehicleYear"] = vehicleYear
            attributes["vehicleNo"] = vehicleNo
            attributes["vehicleMakeId"] = vehicleMakeID
            attributes["colorId"] = colorID
            attributes["city_id"] = cityID
            attributes["request_ride_type"] = request_ride_type
            updateVehicle(attributes)
        }
    }
    

    func fetchDocumentsList(_ cityID: Int,rideType: Int,completion:@escaping() -> Void) {
        var paramToModifyVehicleDetails: JSONDictionary {
            var attributes = [String:Any]()
            attributes["city_id"] = cityID
            attributes["request_ride_type"] = rideType
            
            return attributes
        }

        WebServices.getVehicleFeature(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? VehicleFeatures else { return }
                self?.vehicleFeatures = data
                printDebug(data)
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func updateVehicle(_ attributes: [String: Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.updateVehicleApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
