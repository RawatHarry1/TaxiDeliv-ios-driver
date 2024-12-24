//
//  HomeViewModel.swift
//  VenusDriver
//
//  Created by Amit on 21/08/23.
//

import Foundation

class VDHomeViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var otpVerifiedCallBack: ((UserModel) -> ()) = { _ in}
    var changeAvailabilityCallBack: ((Bool , String) -> ()) = { _,_  in}
    var rideDetailsCallBack : ((RideDetails) -> ()) = { _ in}
    var rejectRideSuccessCallBack : ((Bool) -> ()) = { _ in }
    var tripStartedSuccessCallBack : ((Bool) -> ()) = { _ in }
    var markArrivedSuccessCallBack : ((Bool) -> ()) = { _ in }
    var endRideSuccessCallBack : ((EndRideModel) -> ()) = { _ in }
    var fetchOngoingRideSuccessCallback : ((Bool) -> ()) = { _ in } // Fetch ongoing ride success callback
    var rideCancelledSuccessCallBack : ((BlockDriverModel) -> ()) = { _ in } // Ride Cancelled
    var polylineCallBack: ((String) -> ())?
    var distanceThresholdValue = 20

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    var rideDetails: RideDetails! {
        didSet {
            self.rideDetailsCallBack(rideDetails)
        }
    }

    var endRideDetails : EndRideModel! {
        didSet {
            self.endRideSuccessCallBack(endRideDetails)
        }
    }

    var cancelRideModel : BlockDriverModel! {
        didSet {
            self.rideCancelledSuccessCallBack(cancelRideModel)
        }
    }
    
    override init() {
        super.init()
    }
}

extension VDHomeViewModel {

    func changeDriverAvailability(_ flag : Int) {
        if let _ = LocationTracker.shared.lastLocation {
        } else {
            SKToast.show(withMessage: "Not able to fetch your location.")
            return
        }

        var paramToModifyVehicleDetails: JSONDictionary {
            var attributes = [String:Any]()
            if let locationCreds = LocationTracker.shared.lastLocation {
                attributes["longitude"] = locationCreds.coordinate.longitude
                attributes["latitude"] = locationCreds.coordinate.latitude
            }
            attributes["flag"] = flag
            return attributes
        }

        WebServices.changeDriverAvailabilityu(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let docs = data as? JSON else { return }
                guard let docObject = docs.dictionaryObject else { return }
                guard let dataObj = docObject["data"] as? [String: Any] else { return }
                guard let docStatus = dataObj["docStatus"] as? String else { return }
                guard let autos_available = dataObj["autos_available"] as? Int else { return }
                self?.changeAvailabilityCallBack((autos_available == 1) , docStatus) // flag == 1

            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func getDriverStatus() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String:Any]()
        }

        WebServices.getDocumentList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let docs = data as? DocumentList else { return }
                guard let docList = docs.list else { return }

                var isDocumentsApproved = true
                for doc in docList {
                    if doc.doc_status != "APPROVED" {
                        isDocumentsApproved = false
                    }
                }
                self?.successCallBack(isDocumentsApproved)
                printDebug(docList)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }


    func acceptRideApi(_ attributes: [String:Any],completionFaliur:@escaping ((String) -> Void)) {

        var paramToModifyVehicleDetails: JSONDictionary {
            var updatedAtt = attributes
//            if let locationCreds = LocationTracker.shared.lastLocation {
//                updatedAtt["longitude"] = locationCreds.coordinate.longitude
//                updatedAtt["latitude"] = locationCreds.coordinate.latitude
//            }
            return updatedAtt
        }

        WebServices.acceptTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let rides = data as? RideDetails else { return }
                self?.rideDetails = rides
            case .failure(let error):
                completionFaliur(error.localizedDescription)
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func rejectRideApi(_ attributes: [String:Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }
        WebServices.rejectTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let _ = data as? JSON else { return }
                self?.rejectRideSuccessCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }


    func cancelRideApi(_ engagementID: String , _ customerId : String, _ cancellationReason: String) {
        var paramToModifyVehicleDetails: JSONDictionary {
               var attributes = [String:Any]()
            attributes["engagementId"] = engagementID
            attributes["customerId"] = customerId
            attributes["cancellationReason"] = cancellationReason
            attributes["by_operator"] = 1
            return attributes
        }

        WebServices.cancelTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let dataModel = data as? BlockDriverModel else { return }
                self?.cancelRideModel = dataModel
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func markArrivedTrip(_ attributes : [String : Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.markArrivedTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let _ = data as? JSON else { return }
                self?.markArrivedSuccessCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func startTrip(_ attributes : [String : Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.startTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let _ = data as? JSON else { return }
                self?.tripStartedSuccessCallBack(true)
                sharedAppDelegate.notficationDetails?.status = rideStatus.customerPickedUp.rawValue
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func fetchAvailableRide() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String:Any]()
        }

        WebServices.fetchOngoingTrip(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let rideDetails = data as? OngoingRideModel else {
                    printDebug("Failed to fetch ongoing trips")
                    return
                }
                guard let currentRides = rideDetails.trips else {
                    printDebug("Failed to fetch ongoing trips")
                    return
                }
                if currentRides.count > 0 {
                    VDUserDefaults.save(value: true, forKey: .isDriverAvailable)
                    sharedAppDelegate.notficationDetails = currentRides[0]
                } else {
                    VDUserDefaults.save(value: ((rideDetails.is_driver_online ?? 0) == 1), forKey: .isDriverAvailable)
                    sharedAppDelegate.notficationDetails = nil
                    RideStatus = .none
                }
                self?.fetchOngoingRideSuccessCallback(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func endRideApi(_ attributes: [String: Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.completeTripApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let endRide = data as? EndRideModel else { return }
                self?.endRideDetails = endRide
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }


    func getNewPolyline(_ origin: String, _ destination: String) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["mode"] = "driving"
            attribute["destination"] = destination
            attribute["origin"] = origin
            attribute["key"] = googleAPIKey
            return attribute
        }

        WebServices.getNewTripPolyline(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                if let overview_polyline = data as? [String:Any] {
                    let point = overview_polyline["points"] as! String
                    self?.polylineCallBack?(point)
                }

            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
