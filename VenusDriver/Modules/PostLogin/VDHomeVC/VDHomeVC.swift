//
//  VDHomeVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit
import GoogleMaps
import LGSideMenuController
var navigateToChatOnce = false
var navigateToChat = false
class VDHomeVC: VDBaseVC {
    // MARK: - Outlets
    @IBOutlet weak private(set) var availabilityButton: UIButton!
    @IBOutlet weak private(set) var offlineView: VDView!
    @IBOutlet weak private(set) var mapView: GMSMapView!
    @IBOutlet weak private(set) var newRideReqView: UIView!
    @IBOutlet weak private(set) var newRideReqDetails: UIView!
    @IBOutlet weak private(set) var cancelRideWhileProcess: VDButton!
    @IBOutlet weak private(set) var rideProcessingView: UIView!
    @IBOutlet weak private(set) var rideStatusView: UIView!
    @IBOutlet weak private(set) var btnChat: UIButton!
    @IBOutlet weak private(set) var cancelRideBtn: VDButton!
    @IBOutlet weak private(set) var titleLbl: UILabel!

    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var lblReceiverPhoneNumber: UILabel!
    @IBOutlet weak var docPendingView: UIView!
    @IBOutlet weak var viewDot: UIView!
    // New Ride View
    @IBOutlet weak var customerProfileImg: UIImageView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pickUpLocationLbl: UILabel!
    @IBOutlet weak var dropLocationLbl: UILabel!
    
    //Verification Popup
    @IBOutlet weak var verificationPopUpIconImg: UIImageView!
    @IBOutlet weak var verificationPopUpMessageLbl: UILabel!
    @IBOutlet weak var verificationPopUpActionBtn: VDButton!

    //Timer to update location
    private var timerToUpdateDriverLocation: Timer?
    private let timerIntervalToRefersh: TimeInterval = 4.0

    // Update Ride Status
    @IBOutlet weak var completRideLbl: UILabel!

    @IBOutlet weak var arrivedStatusLbl: UILabel!
    @IBOutlet weak var ontheWayDestinationLbl: UILabel!
    @IBOutlet weak var completeRideLbl: UILabel!

    @IBOutlet weak var arrivedRadioImg: UIImageView!
    @IBOutlet weak var onTheWayRadioImg: UIImageView!
    @IBOutlet weak var radioDestinationImg: UIImageView!

    @IBOutlet weak var pickToOnTheWayLbl: UILabel!
    @IBOutlet weak var OntheWayToDestinationLbl: UILabel!

    // MARK: - Variables
   // var locationManager = CLLocationManager()
     var homeViewModel: VDHomeViewModel = VDHomeViewModel()
     var tripID: String?
    var customerID = ""
    var isUpdateOnce = true
    var profileImg = ""
    var profileName = ""
    var markerUser : GMSMarker?
    var shouldUpdateCamera = true
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()

    var completeGmsPath : GMSPath?
    var travelledGmsPath : GMSPath?
    var completePolyline : GMSPolyline?
    var travelledPolyline : GMSPolyline?
//    var infoWindowETA : MarkerInfoView?
    var requestedPathCoordinates : CLLocationCoordinate2D?
    var polyLinePath = ""
    var isStartTrip = false
    var rideStatusTitle = "Slide to end trip"
    var previousLocation: CLLocation?
    
    var currentLat = 0.0
    var currentLong = 0.0
    var cameraUpdateOnce = true
    var coordinates = CLLocation()
    // TODO: - DEINIT METHOD
    deinit {
        //NotificationCenter.default.removeObserver(self)
        stopTimer()
    }

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDHomeVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        callIndidLoad()
        callBacks()
      //  let obj = ClientModel.currentClientData
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appWillEnterForeground() {
        callIndidLoad()
    }
    
    func callIndidLoad(){
        homeViewModel.fetchAvailableRide()
    }
    
    override func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees){
        
        if lat != 0{
            self.coordinates =  CLLocation(latitude: lat, longitude: long)
            _ = CLLocationCoordinate2D(latitude: lat, longitude: long)
            DispatchQueue.main.async {
                self.refreshMap(self.coordinates)
            }
        }
        
        self.currentLat = lat
        self.currentLong = long
        
//        if distance >= 10 {
//            startTimerToUpdateDriverLocation()
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationServices()
        checkNotificationStatusAndPrompt()
        let isDriverAvailablecheck = VDUserDefaults.value(forKey: .isDriverAvailable)
       
        let valueCheck = isDriverAvailablecheck.rawValue as? Bool
        if valueCheck == false{
            self.homeViewModel.changeDriverAvailability(0)
           
        }else{
           
            self.homeViewModel.changeDriverAvailability(1)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let location = LocationTracker.shared.lastLocation {
                self.refreshMap(location)
            }
        }
       
        
        let isDriverAvailable = VDUserDefaults.value(forKey: .isDriverAvailable)
        if let value = isDriverAvailable.rawValue as? Bool {
            self.handleDriverAvailability(value)
        }

        if let notificationModel = sharedAppDelegate.notficationDetails {
            if notificationModel.service_type == 2{
                viewDelivery.isHidden = false
            }else{
                viewDelivery.isHidden = true
            }
            tripID = notificationModel.trip_id
            profileName = notificationModel.customer_name ?? ""
            profileImg = notificationModel.customer_image ?? ""
            if notificationModel.status == notificationTypes.new_ride_request.rawValue {
//                RideStatus = .availableRide
                updateUIAccordingtoRideStatus()
                updateAvailableRidePopUp()
//                self.availabilityButton.isEnabled = false
            } else if notificationModel.status == rideStatus.markArrived.rawValue || notificationModel.status == rideStatus.acceptedRide.rawValue || notificationModel.status == rideStatus.customerPickedUp.rawValue{
//                RideStatus = .acceptedRide
                homeViewModel.fetchAvailableRide()
                updateUIAccordingtoRideStatus()
                //                self.availabilityButton.isEnabled = false
            }
            //         else if notificationModel.status == rideStatus.customerPickedUp.rawValue {
            //            self.newRideReqView.isHidden = true
            //            self.rideProcessingView.isHidden = true
            //            self.rideStatusView.isHidden = false }
            else {
//                self.availabilityButton.isEnabled = true
                RideStatus = .none
                updateUIAccordingtoRideStatus()
            }

            tripStartedAction()

        } else {
            homeViewModel.fetchAvailableRide()
            tripID = nil
        }
        
        // Update Location accuratly
        if let location = LocationTracker.shared.lastLocation {
            self.refreshMap(location)
        }

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLayoutSubviews() {
        newRideReqView.addShadowView(color: VDColors.buttonBorder.color)
        newRideReqView.roundCorner([.topLeft, .topRight], radius: 20)
        newRideReqDetails.roundCorner([.topLeft, .topRight], radius: 20)
        rideProcessingView.addShadowView(color: VDColors.buttonBorder.color)
        rideProcessingView.roundCorner([.topLeft, .topRight], radius: 20)
        rideStatusView.addShadowView(color: VDColors.buttonBorder.color)
        rideStatusView.roundCorner([.topLeft, .topRight], radius: 20)
//        rideStatusView.isHidden = false
        // Assuming you have a reference to your mapView
        let googleLogoCover = UIView()
        
        // Position the cover view over the Google logo (usually bottom-left)
        googleLogoCover.frame = CGRect(x: 10, y: self.mapView.frame.height - 40, width: 80, height: 20) // Adjust according to the logo size
        googleLogoCover.backgroundColor = UIColor.clear

        // Add the view to cover the Google logo
        self.mapView.addSubview(googleLogoCover)

        // This will block the tap on the Google logo
    }
    
  
    @objc func observerForNewRideRequest(notification: Notification) {
            if let notificationModel = sharedAppDelegate.notficationDetails {
//                if type.rawValue == notificationTypes.new_ride_request.rawValue {
                    RideStatus = .availableRide
                    updateUIAccordingtoRideStatus()
//                }
//            }
        }
    }

    @objc func clearOngoingNotification(notification: Notification) {
        RideStatus = .none
       // driverMarker = nil
        btnChat.isHidden = true
        driverMarker.icon = VDImageAsset.vehicleMarker.asset
        driverMarker.isFlat = true
        driverMarker.map = nil
        DispatchQueue.main.async {
            self.refreshMap(self.coordinates)
        }
        updateUIAccordingtoRideStatus()
        homeViewModel.fetchAvailableRide()
    }
    
    @objc func refreshWalletBalance(notification: Notification) {
        if sharedAppDelegate.notficationDetails == nil {
            self.handleValidationPopUp()
        }
    }
    @objc func newMessageNotify(notification: Notification) {
        viewDot.isHidden = true
        if navigateToChatOnce == true{
          
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
            vc.tripID = self.tripID ?? ""
            vc.customer_id = self.customerID
            vc.profileImg = self.profileImg
            vc.name = self.profileName
            if self.navigationController != nil{
                navigateToChatOnce = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }

    @objc func cancelRideOnSwipe() {
        if RideStatus == .acceptedRide {
            
            if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
                var att = [String:Any]()
                att["tripId"] = tripID
                att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""

                if let locationCreds = LocationTracker.shared.lastLocation {
                    att["pickupLongitude"] = locationCreds.coordinate.longitude
                    att["pickupLatitude"] = locationCreds.coordinate.latitude
                }
                homeViewModel.markArrivedTrip(att)
            }
        } else if RideStatus == .markArrived {
            var att = [String:Any]()
            att["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
            att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id

            if let locationCreds = LocationTracker.shared.lastLocation {
                att["pickupLongitude"] = locationCreds.coordinate.longitude
                att["pickupLatitude"] = locationCreds.coordinate.latitude
            } else {
                    SKToast.show(withMessage: "Not able to fetch your location.")
                    return
            }
            homeViewModel.startTrip(att)
        } else {
            var attributes = [String: Any]()

            if let locationCreds = LocationTracker.shared.lastLocation {
                attributes["dropLatitude"] = locationCreds.coordinate.latitude
                attributes["dropLongitude"] = locationCreds.coordinate.longitude
            }
            attributes["customerId"] = sharedAppDelegate.notficationDetails?.customer_id
            attributes["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
            attributes["rideTime"] = 12
            attributes["waitTime"] = 3

            homeViewModel.endRideApi(attributes)
        }
    }
    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
        if markerUser == nil {
            markerUser = GMSMarker(position: coordinates)
            markerUser?.icon = UIImage(named: "locationMarker")
            markerUser?.isDraggable = true
            markerUser?.map = mapView
        } else {
            markerUser?.position = coordinates
        }

        let camera = GMSCameraPosition(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
        self.mapView.animate(to: camera)
    }
//    func addMarkerToPosition(_ coordinates: CLLocationCoordinate2D) {
//        mapView.clear()
//        markerUser?.map = nil
//
//        markerUser = GMSMarker(position: coordinates)
//        markerUser?.icon = UIImage(named: "locationMarker")
//      //  markerUser?.isFlat = false
//        markerUser?.position = coordinates
//        markerUser?.isDraggable = true
//        markerUser?.map = mapView
//        let camera = GMSCameraPosition.init(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
//        //        self.viewMap.camera = camera
//        self.mapView.animate(to: camera)
//    }
}

// MARK: - Custom functions
extension VDHomeVC {
    
    func handleDriverAvailability(_ isAvailable: Bool) {
       // self.setUpMap()
        self.handleLocationUpdates()
        self.addCancelButtonGesture()
        self.handleApiForAvailability() // Handle api for change availability
        self.updateUIAccordingtoRideStatus()
        self.addObservers()
        self.callBacks() // Handle all api callbacks
        self.handleValidationPopUp()
        if isAvailable  {
            VDUserDefaults.save(value: true, forKey: .isDriverAvailable)
            self.availabilityButton.isSelected = true
            self.offlineView.isHidden = true
            self.titleLbl.text = "Online"
        } else {
            VDUserDefaults.save(value: false, forKey: .isDriverAvailable)
            self.availabilityButton.isSelected = false
            self.offlineView.isHidden = false
            self.titleLbl.text = "Offline"
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerForNewRideRequest(notification:)), name: .newRideRequest, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearOngoingNotification(notification:)), name: .clearNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWalletBalance(notification:)), name: .updateWalletBalance, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageNotify(notification:)), name: .newMessage, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.messageReceiver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: NSNotification.Name.screenRefresh, object: nil)
       
    }
    
    @objc func refresh(_ notification: Notification) {
        self.homeViewModel.fetchAvailableRide()

    }
    
    @objc func handleNotification(_ notification: Notification) {
        self.viewDot.isHidden = false

    }

    func addCancelButtonGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.cancelRideOnSwipe))
        swipeGestureRecognizer.direction = .right // Add this if you want only one direction
        cancelRideBtn.addGestureRecognizer(swipeGestureRecognizer)
    }

    func handleApiForAvailability() {
//        homeViewModel.getDriverStatus()
//        homeViewModel.successCallBack = { status in
//            if !status {
////                self.showVarifyDocumentsPopUp()
//            }
//        }
    }

    func handleLocationUpdates() {
        if LocationTracker.shared.isLocationPermissionGranted() {
            LocationTracker.shared.enableLocationServices()
        } else {
            DispatchQueue.main.async {
                LocationTracker.shared.enableLocationServices()
            }
        }
        DispatchQueue.main.async {
           // LocationTracker.shared.locateMeCallback = { location in
              //  self.refreshMap(location ?? CLLocation(latitude: 30.7046, longitude: 76.7179))
            //}
        }
    }

    func updateUIAccordingtoRideStatus() {
        self.availabilityButton.isUserInteractionEnabled = false
        if timerToUpdateDriverLocation == nil {
            startTimerToUpdateDriverLocation()
        }
        
        // Fetch the current location
//        let currentLocation = LocationTracker.shared.lastLocation
//
//        // Check if the previous location exists
//        if let previousLocation = previousLocation, let currentLocation = currentLocation {
//            // Calculate the distance between the previous and current location
//            let distance = currentLocation.distance(from: previousLocation)
//            print(distance)
//            // If the distance is greater than or equal to 10 meters, start the timer
//            if distance >= 10 {
//                startTimerToUpdateDriverLocation()
//                // Update the previous location to the current location
//                self.previousLocation = currentLocation
//            }
//        } else {
//            // If there's no previous location, set the current location as the previous one
//            previousLocation = currentLocation
//        }
  
        updateOngoingRideStatusPopUp()
        switch RideStatus {
        case .none :
            audioPlayer?.stop()
            self.availabilityButton.isUserInteractionEnabled = true
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = true
//            stopTimer() // Stop timer to update driver location when driver is not taking any rides
        case .availableRide :
            newRideReqView.isHidden = false
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = true
            
            updateAvailableRidePopUp()
        case .acceptedRide :
           // Write code for driver is in proress to pick up driver
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            cancelRideBtn.setTitle("Slide to Mark Arrived", for: .normal)
            btnChat.isHidden = false
//            let obj = VDRideCompleteVC.create(2)
////            obj.endRideModel = endRideStatus
//            obj.markArrived = { status  in
               // self.updateUIAccordingtoRideStatus()
//            }
//            obj.modalPresentationStyle = .overFullScreen
//            self.navigationController?.pushViewController(obj, animated: true)
////            present(obj, animated: true)

        case .markArrived :
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            cancelRideBtn.setTitle("Slide to Start Trip", for: .normal)

        case .customerPickedUp :

            printDebug("Customer picked up")
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            cancelRideBtn.setTitle("Slide to Complete Trip", for: .normal)
            btnChat.isHidden = false
//            if sharedAppDelegate.isFromNotification {
//                newRideReqView.isHidden = true
//                rideProcessingView.isHidden = true
//                rideStatusView.isHidden = false
//            } else {
//                var att = [String:Any]()
//                att["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
//                att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id
//
//                if let locationCreds = LocationTracker.shared.lastLocation {
//                    att["pickupLongitude"] = locationCreds.coordinate.longitude
//                    att["pickupLatitude"] = locationCreds.coordinate.latitude
//                } else {
//                        SKToast.show(withMessage: "Not able to fetch your location.")
//                        return
//                }
//                homeViewModel.startTrip(att)
//            }

        default:
           
            self.availabilityButton.isUserInteractionEnabled = true
            break
        }
    }

    func updateOngoingRideStatusPopUp() {
        if RideStatus == .acceptedRide {
            completRideLbl.text = "Ride Accepted"
            arrivedRadioImg.image = VDImageAsset.radioDisable.asset
            onTheWayRadioImg.image = VDImageAsset.radioDisable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textFieldBorder.color
            ontheWayDestinationLbl.textColor = VDColors.textFieldBorder.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.textFieldBorder.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        } else if RideStatus == .markArrived {
            completRideLbl.text = "Marked Arrived"
            arrivedRadioImg.image = VDImageAsset.radioEnable.asset
            onTheWayRadioImg.image = VDImageAsset.radioDisable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textColor.color
            ontheWayDestinationLbl.textColor = VDColors.textFieldBorder.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.textFieldBorder.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        } else if RideStatus == .customerPickedUp {
            completRideLbl.text = "Trip Started"
            arrivedRadioImg.image = VDImageAsset.radioEnable.asset
            onTheWayRadioImg.image = VDImageAsset.radioEnable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textColor.color
            ontheWayDestinationLbl.textColor = VDColors.textColor.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.buttonSelectedOrange.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        }

    }

    func showVarifyDocumentsPopUp() {
        let vc = VDDocumentVerificationVC.create()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }

    func updateAvailableRidePopUp() {
        if let notificationModel = sharedAppDelegate.notficationDetails {
            tripID = notificationModel.trip_id
            customerID = notificationModel.customer_id ?? ""
            profileImg = notificationModel.customer_image ?? ""
            profileName = notificationModel.customer_name ?? ""
            if notificationModel.status == notificationTypes.new_ride_request.rawValue {
                if let urlStr = notificationModel.customer_image {
                    self.customerProfileImg.setImage(withUrl: urlStr) { status, image in
                        if status {
                            if let img = image {
                                self.customerProfileImg.image = img
                            }
                        }
                    }
                } else {
                    self.customerProfileImg.image = VDImageAsset.imgPlaceholder.asset
                }

                self.customerNameLbl.text = notificationModel.customer_name ?? ""
                
                if let estimatedFare = notificationModel.estimated_driver_fare,
                   let currency = notificationModel.currency,
                   estimatedFare.contains(currency) {
                    // Do something when estimated fare contains the currency
                    self.amountLbl.text = "\(notificationModel.estimated_driver_fare ?? "")"
                } else {
                    self.amountLbl.text = "\(notificationModel.currency ?? "")\(notificationModel.estimated_driver_fare ?? "")"
                    // Do something else if it doesn't contain the currency
                }
                
                
                var distance =  notificationModel.estimated_distance ?? ""
             //   if notificationModel.distanceUnit ?? "" != ""{
                //    self.distanceLbl.text = "\(distance ?? "")\(notificationModel.distanceUnit ?? "")"
               // }else{
                self.distanceLbl.text = "\(distance)"
                //}
                
                self.pickUpLocationLbl.text = notificationModel.pickup_address ?? ""
                self.dropLocationLbl.text = notificationModel.drop_address ?? ""
            }
        }
    }
    
    func formatToOneDecimalPlace(from string: String) -> String? {
        // Convert the string to a Double
        guard let number = Double(string) else {
            print("Invalid number format")
            return nil
        }

        // Create a NumberFormatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1

        // Format the number to one decimal place
        guard let formattedString = formatter.string(from: NSNumber(value: number)) else {
            print("Number formatting failed")
            return nil
        }

        return formattedString
    }

    
    func handleValidationPopUp() {
        guard let userData = UserModel.currentUser.login else {return}
        guard let docStatus = userData.driver_document_status?.requiredDocsStatus else {return}
        validateUserStatus(docStatus)
    }
    
    func validateUserStatus(_ docStatus: String) {
//        self.availabilityButton.isEnabled = true
        docPendingView.isHidden = true
        guard let userData = UserModel.currentUser.login else {return}
        
        if docStatus.uppercased() != DocumentStatus.approved.rawValue {
            switch docStatus.uppercased() {
            case DocumentStatus.rejected.rawValue , DocumentStatus.expired.rawValue :
                showVerificationFailedPopUp(.failedVarification)
                verificationPopUpActionBtn.removeTarget(nil, action: nil, for: .allEvents)
                verificationPopUpActionBtn.addTarget(self, action: #selector(uploadDocumentAction(_:)), for: .touchUpInside)
//                self.availabilityButton.isEnabled = false
                return
            case DocumentStatus.pending.rawValue :
                showVerificationFailedPopUp(.pendingVerification)
//                self.availabilityButton.isEnabled = false
                return
            default:
                printDebug("")
            }
        }
        
        guard let balance = userData.actual_credit_balance , let minBalance = userData.min_driver_balance else {return}

        if balance < minBalance {
            // Show Balance Pop up
//            self.availabilityButton.isEnabled = false
            showVerificationFailedPopUp(.lowBalance)
            return
        }
        
        guard let isUserBlocked = UserModel.currentUser.login?.driver_blocked_multiple_cancelation else { return }
        
        if isUserBlocked.blocked == 1 {
            // User is blocked
//            self.availabilityButton.isEnabled = false
            showVerificationFailedPopUp(.userBlocked)
            return
        }
        
        guard let thresholdReached = UserModel.currentUser.login?.is_threshold_reached else { return }
        
        if thresholdReached == 1 {
            // Threshold reached
//            self.availabilityButton.isEnabled = false
            showVerificationFailedPopUp(.thresholdReached)
            return
        }
    }
    
    func showVerificationFailedPopUp(_ type : ValidationFailedPopUpType) {
        verificationPopUpIconImg.image = type.icon ?? UIImage()
        verificationPopUpMessageLbl.text = type.desc
        verificationPopUpActionBtn.setTitle(type.buttonText, for: .normal)
        verificationPopUpActionBtn.isHidden = type.showButton
        docPendingView.isHidden = false
        
    }
    
    @objc func uploadDocumentAction(_ button: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.rootViewController = VDDocumentVC.create()
    }
}

// MARK: - CALLBACKS
extension VDHomeVC {
    func callBacks() {
        // TODO: - FetchOngoingRideCallBack
        homeViewModel.fetchOngoingRideSuccessCallback = { [weak self] status in
           
            self?.fetchOnGoingRideSuccess()
        }
        
        // TODO: - ChangeavailabilityCallBack
        homeViewModel.changeAvailabilityCallBack = { [weak self] (status , docStatus) in
            
            // Update the latest doc status in application
            var currentUser = UserModel.currentUser
            currentUser.login!.driver_document_status?.requiredDocsStatus = docStatus
            UserModel.currentUser = currentUser
            self?.validateUserStatus(docStatus)
            self?.changeAvailabilitySuccess(status, docStatus)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let location = LocationTracker.shared.lastLocation {
                    self?.refreshMap(location)
                }
            }
        }
        
        // TODO: - RejectRideSuccessCallBack
        homeViewModel.rejectRideSuccessCallBack = { status in
            RideStatus = .none
            sharedAppDelegate.notficationDetails = nil
            self.updateUIAccordingtoRideStatus()
        }

        // TODO: - MARK ARRIVED CALLBACK
        homeViewModel.markArrivedSuccessCallBack = { status in
            self.shouldUpdateCamera = true
            RideStatus = .markArrived
            self.updateUIAccordingtoRideStatus()
            self.homeViewModel.fetchAvailableRide()
            self.isStartTrip = false
           // self.tripStartedAction()
        }

        // TODO: - TripStartedSuccessCallBack
        homeViewModel.tripStartedSuccessCallBack = { tripStarted in
            self.shouldUpdateCamera = true
            self.isStartTrip = true
            self.newRideReqView.isHidden = true
            self.rideProcessingView.isHidden = true
            self.rideStatusView.isHidden = false
            RideStatus = .customerPickedUp
            self.updateUIAccordingtoRideStatus()
            //self.mapView.clear()
            self.tripStartedAction()
        }

        // TODO: - EndRideSuccessCallBack
        homeViewModel.endRideSuccessCallBack = { endRideStatus in
            self.shouldUpdateCamera = true
            RideStatus = .none
            sharedAppDelegate.notficationDetails = nil
            sharedAppDelegate.isFromNotification = false
            self.updateUIAccordingtoRideStatus()
            let obj = VDRideCompleteVC.create(0)
            obj.endRideModel = endRideStatus
            obj.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(obj, animated: true)
                //present(obj, animated: true)
        }

        // TODO: - Draw polyline callback
        //
        homeViewModel.polylineCallBack = { polyline in
           
            self.polyLinePath = polyline
            self.drawpolyLineForRide(polyline)
           // self.showPath(polyStr: polyline)
        }
    }
    
    func fetchOnGoingRideSuccess() {
        // Handle availability
        let isDriverAvailable = VDUserDefaults.value(forKey: .isDriverAvailable)
        if let value = isDriverAvailable.rawValue as? Bool {
            self.handleDriverAvailability(value)
        }

        if let notification = sharedAppDelegate.notficationDetails {
            let status = notification.status ?? "0"
            RideStatus = rideStatus(rawValue: status) ?? .none
            tripID = notification.trip_id
            self.lblReceiverName.text = notification.recipient_name ?? ""
            self.lblReceiverPhoneNumber.text = notification.recipient_phone_no ?? ""
            self.profileImg = notification.customer_image ?? ""
            self.profileName = notification.customer_name ?? ""
            
            if notification.service_type == 2{
                viewDelivery.isHidden = false
            }else{
                viewDelivery.isHidden = true
            }
           
            if RideStatus == .customerPickedUp {
                btnChat.isHidden = false
                self.newRideReqView.isHidden = true
                self.rideProcessingView.isHidden = true
                self.rideStatusView.isHidden = false
                self.updateUIAccordingtoRideStatus()
            } else if RideStatus == .availableRide {
              //  btnChat.isHidden = false
                self.updateAvailableRidePopUp()
                self.updateUIAccordingtoRideStatus()
            } else if RideStatus == .markArrived {
                btnChat.isHidden = false
                self.newRideReqView.isHidden = true
                self.rideProcessingView.isHidden = true
                self.rideStatusView.isHidden = false
                self.updateUIAccordingtoRideStatus()
            }else {
                self.updateUIAccordingtoRideStatus()
            }
            self.tripStartedAction()

        } else {
            tripID = nil
        }
    }
    
    func changeAvailabilitySuccess(_ status: Bool , _ docStatus: String) {
        var value = status
        if docStatus.lowercased() != "approved" {
            RideStatus = .none
            sharedAppDelegate.isFromNotification = false
            RideStatus = .none
            sharedAppDelegate.notficationDetails = nil
            self.updateUIAccordingtoRideStatus()
            value = false
            validateUserStatus(docStatus)
        }
        // Handle availability
        self.handleDriverAvailability(value)
    }
    
}

// MARK: - Ride Actions
extension VDHomeVC {
    // TODO: - Open Accept Ride Screen
    func openAcceptRideScreen() {
       // DispatchQueue.main.async {
            self.dismiss(animated: true) {
                let obj = VDRideCompleteVC.instantiate(fromAppStoryboard: .postLogin)
                obj.screenTyoe = 1
                //let obj = VDRideCompleteVC.create(1)
                obj.modalPresentationStyle = .overFullScreen
                obj.markArrived = { status  in
                    self.updateUIAccordingtoRideStatus()
                }
                self.navigationController?.pushViewController(obj, animated: true)
            }
      //  }
     
            //.present(obj, animated: true)
    }
}

// MARK: - IBActions
extension VDHomeVC {
    @IBAction func chatBtn(_ sender: UIButton) {
        self.viewDot.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VDChatVC") as! VDChatVC
        vc.tripID = self.tripID ?? ""
        vc.customer_id = self.customerID
        vc.profileImg = self.profileImg
        vc.name = self.profileName
        self.navigationController?.pushViewController(vc, animated: true)
       // self.navigationController?.pushViewController(VDChatVC.create(), animated: true)
    }

    @IBAction func btnSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: .openSideMenu, object: nil)
    }

    @IBAction func btnAvailability(_ sender: UIButton) {
        // TODO: - APICALL FOR CHANGE AVAILABILITY
       
        self.homeViewModel.changeDriverAvailability(availabilityButton.isSelected ? 0 : 1)
    }

    @IBAction func btnAcceptRide(_ sender: UIButton) {
        audioPlayer?.stop()
        openAcceptRideScreen()
    }

    @IBAction func btnCancelRideProcessing(_ sender: UIButton) {
       
        rideProcessingView.isHidden = true
        rideStatusView.isHidden = false
    }

    @IBAction func cancelRideOngoing(_ sender: UIButton) {

    }
    
    @IBAction func btnCancelRideAction(_ sender: UIButton) {
        audioPlayer?.stop()
        var attributes = [String: Any]()
        if let locationCreds = LocationTracker.shared.lastLocation {
            attributes["longitude"] = locationCreds.coordinate.longitude
            attributes["latitude"] = locationCreds.coordinate.latitude
        }
        attributes["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
        homeViewModel.rejectRideApi(attributes)
    }

    @IBAction func centerLocationBtn(_ sender: UIButton) {
        // Update Location accuratly
        if let location = LocationTracker.shared.lastLocation {
            self.refreshMap(location)
        }
    }
}



// MARK: - Update Driver Location using timer
extension VDHomeVC {

    // Function to start the timer
    private func startTimerToUpdateDriverLocation() {
        DispatchQueue.global(qos: .background).async {
            self.stopTimer()
            delay(withSeconds: 2) {
                self.timerToUpdateDriverLocation = Timer.scheduledTimer(timeInterval: self.timerIntervalToRefersh, target: self, selector: #selector(self.apiCallforRefreshNearbyDriver(_ :)), userInfo: nil, repeats: true)
            }
        }
    }

    private func stopTimer() {
        timerToUpdateDriverLocation?.invalidate()
        timerToUpdateDriverLocation = nil
    }

    @objc private func apiCallforRefreshNearbyDriver(_ timer: TimeInterval) {
        var objc = [String:Any]()
        guard let trips = sharedAppDelegate.notficationDetails else { return }
        
        if VDUserDefaults.value(forKey: .oldDriverCoordinates) != JSON.null {
            let location = (VDUserDefaults.value(forKey: .oldDriverCoordinates)).object as? [String:Any]
            printDebug(location)
            objc["latitude"] = self.currentLat
            objc["longitude"] = self.currentLong
            objc["direction"] = location?["direction"]
            objc["tripID"] = trips.trip_id
            
            if let currentLocation = LocationTracker.shared.lastLocation {
                let savedLocation = CLLocationCoordinate2D(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
                let calculatedDistance : Int = Int(GMSGeometryDistance(savedLocation, currentLocation.coordinate))
                //   if (calculatedDistance > 20) {
               
               
                
                objc["engagementId"] = tripID
                if let operatorToken = ClientModel.currentClientData.operatorToken {
                    objc["operatorToken"] = operatorToken
                }
                if let accessToken = UserModel.currentUser.access_token {
                    objc["accessToken"] = accessToken
                }
                
                var params : JSONDictionary {
                    return objc
                }
                VCSocketIOManager.shared.emit(with: .locationUpdate, objc, loader: false)
                //                    tripStartedAction()
                var destination = CLLocationCoordinate2D(latitude: (trips.latitude ?? "0.0").double ?? 0.0, longitude: (trips.longitude ?? "0.0").double ?? 0.0)
                
                if (RideStatus == .markArrived) || (RideStatus == .acceptedRide) {
                    // fallback
                } else {
                    destination = CLLocationCoordinate2D(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
                }
                
                var source = CLLocation(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
                
               
                let driverBearing = self.calculateBearing(from: currentLocation.coordinate, to: destination)
                DispatchQueue.main.async {
                  
                    //self.showMarker(Source: source.coordinate, Destination: destination)
                    self.updateMarkersPositionForRide(driverBearing,currentLocation.coordinate , destination, true)
                }
                
                VDUserDefaults.save(value: [(trips.drop_latitude ?? "0.0").double ?? 0.0, (trips.drop_longitude ?? "0.0").double ?? 0.0, driverBearing], forKey: .currentLocation)
                
                //                } else {
                //                    return
                //                }
                
            } else {
                return
            }
        } else {
            if let location = LocationTracker.shared.lastLocation {
                
                objc["latitude"] = (trips.latitude ?? "0.0").double ?? 0.0
                objc["longitude"] = (trips.drop_longitude ?? "0.0").double ?? 0.0
                var bearing: Double = 0.0
                if #available(iOS 13.4, *) {
                    bearing = location.courseAccuracy.magnitude
                } else {
                    
                }
                objc["direction"] = bearing
                objc["tripID"] = trips.trip_id
                VDUserDefaults.save(value: objc, forKey: .oldDriverCoordinates)
            }
        }
    }
    
    func calculateBearing(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = startLocation.latitude.toRadians()
        let lon1 = startLocation.longitude.toRadians()
        
        let lat2 = endLocation.latitude.toRadians()
        let lon2 = endLocation.longitude.toRadians()
        
        let deltaLongitude = lon2 - lon1
        let y = sin(deltaLongitude) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude)
        
        let initialBearing = atan2(y, x).toDegrees()
        return (initialBearing + 360).truncatingRemainder(dividingBy: 360)
    }
}

extension VDHomeVC {
    func tripStartedAction(_ shouldUpdateCameraMovement: Bool = true ) {
        guard let trips = sharedAppDelegate.notficationDetails else { return }

        var user_pickedup = false
        if (RideStatus == .markArrived) || (RideStatus == .acceptedRide) {
           
            user_pickedup = false
        } else {
            user_pickedup = true
        }
        var oldDriverCoordinates: CLLocationCoordinate2D?

        if VDUserDefaults.value(forKey: .oldDriverCoordinates) != JSON.null {
            let savedoldDriverCoordinates = (VDUserDefaults.value(forKey: .oldDriverCoordinates)).object as? [String:Any]
            let tripID = savedoldDriverCoordinates!["tripID"] as? String ?? "0"
            if tripID == trips.trip_id ?? "0" {
                let oldDriverLatitude = savedoldDriverCoordinates!["latitude"] as? Double ?? 0.0
                let oldDriverLongitude = savedoldDriverCoordinates!["longitude"] as? Double ?? 0.0
                oldDriverCoordinates = CLLocationCoordinate2D(latitude: oldDriverLatitude, longitude: oldDriverLongitude)
            } else {
                var newDriverCoordinates = [String:Any]()
                newDriverCoordinates["latitude"] = Double(LocationTracker.shared.lastLocation?.coordinate.latitude ?? 0.0)
                newDriverCoordinates["longitude"] = Double(LocationTracker.shared.lastLocation?.coordinate.longitude ?? 0.0)
                newDriverCoordinates["tripID"] = Int(trips.trip_id ?? "0")
                VDUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
            }
        } else {
            var newDriverCoordinates = [String:Any]()
            newDriverCoordinates["latitude"] = Double(LocationTracker.shared.lastLocation?.coordinate.latitude ?? 0.0)
            newDriverCoordinates["longitude"] = Double(LocationTracker.shared.lastLocation?.coordinate.longitude ?? 0.0)
            newDriverCoordinates["tripID"] = trips.trip_id
            VDUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
        }
        var destinationCoordinatesStr = "\(trips.latitude ?? "0.0")"  + "," +  "\( trips.longitude ?? "0.0")"
        if user_pickedup {
            destinationCoordinatesStr = "\(trips.drop_latitude ?? "0.0")"  + "," +  "\( trips.drop_longitude ?? "0.0")"
        }

        var destination = CLLocationCoordinate2D(latitude: (trips.latitude ?? "0.0").double ?? 0.0, longitude: (trips.longitude ?? "0.0").double ?? 0.0)
        if user_pickedup {
            destination = CLLocationCoordinate2D(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
        }

        let originCoordinates = "\(LocationTracker.shared.lastLocation?.coordinate.latitude ?? 0.0)" + "," + "\(LocationTracker.shared.lastLocation?.coordinate.longitude ?? 0.0)"
        let latestCoordinates = CLLocationCoordinate2D(latitude: LocationTracker.shared.lastLocation?.coordinate.latitude ?? 0.0, longitude: LocationTracker.shared.lastLocation?.coordinate.longitude ?? 0.0)
        var bearing = 0.0
        if let oldDriverCoordinates  = oldDriverCoordinates {
            bearing = Double(getHeadingForDirection(fromCoordinate: oldDriverCoordinates, toCoordinate: latestCoordinates))
        } else {
            if #available(iOS 13.4, *) {
                bearing = LocationTracker.shared.lastLocation?.courseAccuracy.magnitude ?? 0.0
            } else {
                // Fallback on earlier versions
            }
        }
        
        DispatchQueue.main.async {
            let driverCord = "\(latestCoordinates.latitude)"  + "," +  "\(latestCoordinates.longitude)"
            let locCord = "\(destination.latitude)"  + "," +  "\(destination.longitude)"
            self.homeViewModel.getNewPolyline("\(locCord)", "\(driverCord)")
            let driverBearing = self.calculateBearing(from: latestCoordinates, to: destination)
            self.updateMarkersPositionForRide(driverBearing, latestCoordinates, destination, false , shouldUpdateCameraMovement)
        }
       // showMarker(Source: latestCoordinates, Destination: destination)
       
    }
    
    
    //########################### Gurinder ##############################
      
//      func showMarker(Source : CLLocationCoordinate2D, Destination : CLLocationCoordinate2D){
//
//          let driverCord = "\(Source.latitude)"  + "," +  "\(Source.longitude)"
//          let locCord = "\(Destination.latitude)"  + "," +  "\(Destination.longitude)"
//          homeViewModel.getNewPolyline("\(locCord)", "\(driverCord)")
//
//          var bounds = GMSCoordinateBounds()
//          driverMarker.map = nil
//          driverMarker = GMSMarker(position: Source)
//          driverMarker.icon = VDImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
//          driverMarker.isFlat = false
//          driverMarker.zIndex = 0
//          driverMarker.position = Source
//          driverMarker.map = self.mapView
//
//          bounds = bounds.includingCoordinate(driverMarker.position)
//
//          currentMarker.map = nil
//          currentMarker = GMSMarker(position: Destination)
//          currentMarker.icon = VDImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
//          currentMarker.isFlat = false
//          currentMarker.zIndex = 1
//          currentMarker.position = Destination
//          currentMarker.map = mapView
//
//          currentMarker.map = self.mapView
//
//      }

//      func showPath(polyStr :String){ //FROM API
//          self.mapView.clear()
//          guard let path = GMSMutablePath(fromEncodedPath: polyStr) else {return }
//          let markerPostion = path.coordinate(at: 0)
//          let endPos = path.coordinate(at: path.count() - 1)
//
//          self.addMarker(source: markerPostion, destination: endPos)
//          let polyLine = GMSPolyline(path: path)
//          polyLine.strokeWidth = 4.0
//          polyLine.strokeColor = VDColors.buttonSelectedOrange.color
//          polyLine.map = self.mapView
//          var bounds = GMSCoordinateBounds()
//          for index in 1...path.count() {
//              bounds = bounds.includingCoordinate(path.coordinate(at: UInt(index)))
//          }
//         // let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30))
//         // if isUpdateOnce == true{
//            //  isUpdateOnce = false
//              self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 75))
//          //}
//      }
     
//      func addMarker(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
//          DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    self.driverMarker.tracksViewChanges = false
//              self.currentMarker.tracksViewChanges = false
//                }
//          driverMarker = GMSMarker(position: destination)
//          driverMarker.icon = VDImageAsset.vehicleMarker.asset?.withRenderingMode(.alwaysOriginal)
//
//          driverMarker.position = destination
//          driverMarker.zIndex = 0
//          driverMarker.map = mapView
//
//          currentMarker = GMSMarker(position: source)
//          currentMarker.icon = VDImageAsset.locationMarker.asset?.withRenderingMode(.alwaysOriginal)
//          currentMarker.zIndex = 1
//          currentMarker.position = source
//          currentMarker.map = mapView
//      }
      //##############################  END #########################################
    func updateMarkersPositionForRide(_ driverBearing: Double, _ driverCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, _ isNewCoordinates: Bool = false, _ shouldUpdateCameraMovement: Bool = false) {
        
        let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: 400, right: 30)
        mapView.padding = mapInsets
        view.layoutIfNeeded()
        
        // Update Driver Marker
        if driverMarker.map == nil {
            driverMarker = GMSMarker(position: driverCoordinates)
            driverMarker.icon = VDImageAsset.vehicleMarker.asset
            driverMarker.isFlat = true
            driverMarker.map = mapView
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0) // Adjust duration as needed
            driverMarker.position = driverCoordinates
            driverMarker.rotation = driverBearing
            CATransaction.commit()
        }
        
        // Update Destination Marker
        if currentMarker.map == nil {
            currentMarker = GMSMarker(position: destinationCoordinates)
            currentMarker.icon = VDImageAsset.locationMarker.asset
            currentMarker.isFlat = true
            currentMarker.map = mapView
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0) // Adjust duration as needed
            currentMarker.position = destinationCoordinates
            CATransaction.commit()
        }
        
        var bounds = GMSCoordinateBounds()
            let mapCoordinates: [CLLocationCoordinate2D] = [driverCoordinates, destinationCoordinates]
            mapCoordinates.forEach {
                bounds = bounds.includingCoordinate($0)
            }
            
            // Update the camera to fit the bounds of the markers
        if shouldUpdateCamera {
                let update = GMSCameraUpdate.fit(bounds, withPadding: 10)
                mapView.animate(with: update)
                shouldUpdateCamera = false
            }
            
            if isNewCoordinates {
              //  updateTravelledPath(currentLoc: driverCoordinates)
                updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
            }
    }

//    func updateMarkersPositionForRide(_ driverBearing: Double, _ driverCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, _ isNewCoordinates: Bool = false, _ shouldUpdateCameraMovement: Bool = false) {
//
//            let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: 400, right: 30)
//            mapView.padding = mapInsets
//            view.layoutIfNeeded()
//
//
//
//        // Driver Marker
//
//        driverMarker.map = nil
//        driverMarker = GMSMarker(position: driverCoordinates)
//        driverMarker.icon = VDImageAsset.vehicleMarker.asset
//        driverMarker.isFlat = false
//        driverMarker.position = driverCoordinates
//        driverMarker.map = mapView
//        driverMarker.rotation = driverBearing
//
//        // Destination Marker
//
//        currentMarker.map = nil
//        currentMarker = GMSMarker(position: destinationCoordinates)
//        currentMarker.icon = VDImageAsset.locationMarker.asset
//        currentMarker.isFlat = false
//        currentMarker.position = destinationCoordinates
//        currentMarker.map = mapView
//
//
//
////            var bounds = GMSCoordinateBounds()
////                let mapCoordinates: [CLLocationCoordinate2D] = [driverCoordinates, destinationCoordinates]
////                _ = mapCoordinates.map {
////                    bounds = bounds.includingCoordinate($0)
////                }
////            let cameraUpdate = GMSCameraUpdate.setTarget(driverCoordinates)// fit(bounds, withPadding: 30)
////            self.mapView.moveCamera(cameraUpdate)
//        var bounds = GMSCoordinateBounds()
//        let mapCoordinates: [CLLocationCoordinate2D] = [driverCoordinates, destinationCoordinates]
//        _ = mapCoordinates.map {
//            bounds = bounds.includingCoordinate($0)
//        }
//
//        // If you want to update the camera only when needed
//        let currentCameraPosition = self.mapView.camera.target
//        if !bounds.contains(currentCameraPosition) {
//            let cameraUpdate = GMSCameraUpdate.setTarget(driverCoordinates) // Or fit(bounds, withPadding: 30)
//            self.mapView.moveCamera(cameraUpdate)
//        }
//
//
//        if isNewCoordinates {
//            updateCarMovement(destinationCoordinates, driverCoordinates, driverBearing)
//        }
//    }

    func updateCarMovement(_ destinationCoordinates: CLLocationCoordinate2D, _ driverCoordinates: CLLocationCoordinate2D, _ driverBearing: Double, _ shouldUpdateCameraMovement: Bool = true) {
        let zoomLevel : Float = 16
        let _: Float = 2.0
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))

        let oldCoordinates = VDUserDefaults.value(forKey: .oldDriverCoordinates)
        var oldCoodinateLocation : CLLocationCoordinate2D?
        if oldCoordinates != .null {
            let oldDriverCoordinates = (VDUserDefaults.value(forKey: .oldDriverCoordinates)).object as? [String:Any]
            oldCoodinateLocation = CLLocationCoordinate2D(latitude: oldDriverCoordinates!["latitude"] as? Double ?? 0.0, longitude: oldDriverCoordinates!["longitude"] as? Double ?? 0.0)
        }
     //   var calBearing: Float = getHeadingForDirection(fromCoordinate: oldCoodinateLocation ?? "", toCoordinate: driverCoordinates)
       // driverMarker.rotation = CLLocationDegrees(0.0)
        driverMarker.position = oldCoodinateLocation ?? driverCoordinates
        driverMarker.icon = VDImageAsset.vehicleMarker.asset
        driverMarker.isFlat = false
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        driverMarker.rotation = driverBearing // Adjusting the car marker's rotation to face the path direction
        driverMarker.position = driverCoordinates // Update position
        CATransaction.commit()
      //  CATransaction.begin()
       // CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
//        CATransaction.setCompletionBlock({() -> Void in
//            self.driverMarker.rotation = driverBearing
//        })
        if shouldUpdateCameraMovement {
            if mapView.camera.zoom == zoomLevel {
              //  let updateCamera = GMSCameraUpdate.setTarget(driverCoordinates)
               // mapView.moveCamera(updateCamera)
            } else {
               // let updateCamera = GMSCameraUpdate.setTarget(driverCoordinates)
              //  mapView.moveCamera(updateCamera)
                //let updateCamera = GMSCameraUpdate.setTarget(driverCoordinates, zoom : zoomLevel)
                //mapView.moveCamera(updateCamera)
            }
        }
        driverMarker.position = driverCoordinates
        driverMarker.map = mapView
        driverMarker.rotation = driverBearing
       // CATransaction.begin()

        var newDriverCoordinates = [String:Any]()
        newDriverCoordinates["latitude"] = (driverCoordinates.latitude )
        newDriverCoordinates["longitude"] = (driverCoordinates.longitude )
        VDUserDefaults.save(value: newDriverCoordinates, forKey: .oldDriverCoordinates)
        updateTravelledPath(currentLoc: driverCoordinates)
    }


    // MARK: - Update Travelled Path
//    private func updateTravelledPath(currentLoc: CLLocationCoordinate2D) {
//        guard let path = travelledGmsPath else { return }
//
//        // Check if the current location is on the path
//        let isCurrentLocationExistInsidePath = GMSGeometryIsLocationOnPathTolerance(currentLoc, path, true, CLLocationDistance(homeViewModel.distanceThresholdValue))
//
//        if isCurrentLocationExistInsidePath { // Driver is on path
//            requestedPathCoordinates = nil
//            var indexToBeRemoved: UInt?
//            var arrDistances: [Int] = []
//
//            // Calculate distances from the current location to each path coordinate
//            for index in 0..<path.count() {
//                let pathCoordinates = path.coordinate(at: index)
//                let calculatedDistance = Int(GMSGeometryDistance(currentLoc, pathCoordinates))
//                arrDistances.append(calculatedDistance)
//            }
//
//            // Find the index of the smallest distance
//            if let smallestDistance = arrDistances.min(), let smallestDistanceIndex = arrDistances.firstIndex(of: smallestDistance) {
//                indexToBeRemoved = UInt(smallestDistanceIndex)
//
//                // Create a new path excluding the closest segment
//                let newPath = GMSMutablePath()
//                if let indexToBeRemoved = indexToBeRemoved { // Polyline exists
//                    for index in indexToBeRemoved..<path.count() {
//                        newPath.add(path.coordinate(at: index))
//                    }
//
//                    // Remove old polyline
//                    travelledPolyline?.map = nil
//
//                    // Add new polyline
//                    travelledPolyline = GMSPolyline(path: newPath)
//                    travelledPolyline?.strokeColor = VDColors.buttonSelectedOrange.color
//                    travelledPolyline?.strokeWidth = 4.0
//                    travelledPolyline?.map = mapView
//
//                    // Calculate and update camera bounds
//                    var bounds = GMSCoordinateBounds()
//                    for index in 0..<newPath.count() {
//                        bounds = bounds.includingCoordinate(newPath.coordinate(at: index))
//                    }
//
//                  //  let cameraUpdate = GMSCameraUpdate.fit(bounds)
//                  //  mapView.animate(with: cameraUpdate)
//                } else {
//                    print("Travelled coordinates not found")
//                }
//            }
//        } else { // Request new path request
//            tripStartedAction(false)
//        }
//    }

//MARK : 13 August-----------------------------
    private func updateTravelledPath(currentLoc: CLLocationCoordinate2D) {
        guard let path = travelledGmsPath else { return }
        
        let isCurrentLocationExistInsidePath = GMSGeometryIsLocationOnPathTolerance(currentLoc, path, true, CLLocationDistance(homeViewModel.distanceThresholdValue))
        
        if isCurrentLocationExistInsidePath { // Driver is on path
            requestedPathCoordinates = nil
            var indexToBeRemoved: Int?
            var arrDistances: [Int] = []
            var arrPathCoordinates: [CLLocationCoordinate2D] = []

            for index in 0..<path.count() {
                let pathCoordinates: CLLocationCoordinate2D = path.coordinate(at: index)
                arrPathCoordinates.append(path.coordinate(at: index))
                let calculatedDistance: Int = Int(GMSGeometryDistance(currentLoc, pathCoordinates))
                arrDistances.append(calculatedDistance)
            }

            if let smallestDistance = arrDistances.min(), let smallestDistanceIndex = arrDistances.firstIndex(where: { $0 == smallestDistance }) {
                indexToBeRemoved = smallestDistanceIndex

                let newPath = GMSMutablePath()
                if let indexToBeRemoved = indexToBeRemoved { // PolyLine exists
                    for index in indexToBeRemoved..<Int(path.count()) {
                        newPath.add(path.coordinate(at: UInt(index)))
                    }
                    
                    // Update the polyline
                    print("Updating polyline with new path")
                    travelledGmsPath = newPath
                   // travelledPolyline?.map = nil // Remove old polyline
                    travelledPolyline = GMSPolyline(path: newPath)
                    travelledPolyline?.strokeColor = VDColors.buttonSelectedOrange.color
                    travelledPolyline?.strokeWidth = 4.0
                    travelledPolyline?.map = nil
                    travelledPolyline = nil
                    travelledPolyline?.map = mapView // Add new polyline to the map
                    
                    // Optionally update the camera to fit the new polyline
                    var bounds = GMSCoordinateBounds()
                    for index in 0..<newPath.count() {
                        bounds = bounds.includingCoordinate(newPath.coordinate(at: index))
                    }
                   // mapView.animate(with: GMSCameraUpdate.fit(bounds))
                    
                    // updateETAForTravelledPath()
                } else {
                    print("Travelled coordinates not found")
                }
            }
        } else { // Request new path request
            tripStartedAction(false)
        }
    }
//----------------------------------------------------
//    private func updateTravelledPath(currentLoc: CLLocationCoordinate2D) {
//        guard let path = travelledGmsPath else { return }
//        let isCurrentLocationExistInsidePath = GMSGeometryIsLocationOnPathTolerance(currentLoc, path, true, CLLocationDistance(homeViewModel.distanceThresholdValue))
//        if isCurrentLocationExistInsidePath { // Driver is On path
//            requestedPathCoordinates = nil
//            var indexToBeRemoved : Int?
//            var arrDistances : [Int] = [Int]()
//            var arrPathCoordinates : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//            for index in 0..<path.count() {
//                let pathCoordinates : CLLocationCoordinate2D = path.coordinate(at: index)
//                arrPathCoordinates.append(path.coordinate(at: index))
//                let calculatedDistance : Int = Int(GMSGeometryDistance(currentLoc , pathCoordinates))
//                arrDistances.append(calculatedDistance)
//            }
//            if let smallestDistance = arrDistances.min(), let smallestDistanceIndex =  arrDistances.firstIndex(where: { $0 == smallestDistance }) {
//                indexToBeRemoved = Int(smallestDistanceIndex)
//
//                let newPath = GMSMutablePath()
//                if let indexToBeRemoved = indexToBeRemoved { // PolyLine Exist
//                    for index in indexToBeRemoved..<Int(path.count()) {
//                        newPath.add(path.coordinate(at: UInt(index)))
//                    }
//                   // mapView.clear()
//                    travelledGmsPath = newPath
//                 //  travelledPolyline?.map = nil
//                    travelledPolyline = GMSPolyline(path: newPath)
//                    travelledPolyline?.strokeColor = VDColors.buttonSelectedOrange.color
//                    travelledPolyline?.strokeWidth = 4.0
//                    //mapView.clear()
//                    travelledPolyline?.map = mapView
//                    //updateETAForTravelledPath()
//                } else {
//                    printDebug("Travelled coordinats not found")
//                }
//            }
//        } else { //źRequest new path reuqest
//
//            tripStartedAction(false)
//        }
//    }

    func drawpolyLineForRide(_ polyLinePoints: String) {
      
        if let completePolyline = self.completePolyline {
               completePolyline.map = nil
               self.completePolyline = nil
           }
           
           // Remove the existing travelled polyline
           if let travelledPolyline = self.travelledPolyline {
               travelledPolyline.map = nil
               self.travelledPolyline = nil
           }

           // Clear paths if needed
           completeGmsPath = nil
           travelledGmsPath = nil
       
        guard let gmsPath = GMSPath(fromEncodedPath: polyLinePoints), gmsPath.count() > 0 else { return }
        let polyline = GMSPolyline(path: gmsPath)
        polyline.strokeColor = VDColors.buttonSelectedOrange.color
        polyline.strokeWidth = 4.0
        completeGmsPath = gmsPath
        completePolyline = polyline
        travelledGmsPath = completeGmsPath
        travelledPolyline = completePolyline
        
        travelledPolyline?.map = mapView
//        if !hasSetPolyLineBounds {
        
        if isUpdateOnce {
                isUpdateOnce = false
                var bounds = GMSCoordinateBounds()
                for index in 0..<gmsPath.count() {
                    bounds = bounds.includingCoordinate(gmsPath.coordinate(at: index))
                }
                mapView.animate(with: GMSCameraUpdate.fit(bounds))
            }
           
//            hasSetPolyLineBounds = true
//        }
       // handleCarMovement(for: rideType, with: modelRideData, direction: nil)
    }

    // MARK: - Calculate Car Direction Angle
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        let angle = (degree >= 0) ? degree : (360 + degree)
        return angle
    }
}

// MARK: - Floating Point
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension CLLocationDegrees {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
extension VDHomeVC{
    func checkLocationServices() {
          if CLLocationManager.locationServicesEnabled() {
              // Location services are enabled
              checkLocationAuthorization()
          } else {
              // Location services are not enabled, show alert
              showAlertForLocationSettings()
          }
      }

      func checkLocationAuthorization() {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedWhenInUse, .authorizedAlways:
              // Location is authorized, you can start getting location updates
              locationManager.startUpdatingLocation()
             
          case .denied, .restricted:
              // User denied location services, show alert
              showAlertForLocationSettings()
          case .notDetermined:
              // First-time permission request
              locationManager.requestWhenInUseAuthorization()
          @unknown default:
              break
          }
      }

      func showAlertForLocationSettings() {
          let alertController = UIAlertController(
              title: "Location Services Off",
              message: "Enable location to receive ride requests from nearby customers and navigate easily to pick-up and drop-off locations.",
              preferredStyle: .alert
          )

          let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                  return
              }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                      print("Settings opened: \(success)") // Prints true
                  })
              }
          }
         //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

          alertController.addAction(settingsAction)
         // alertController.addAction(cancelAction)

          present(alertController, animated: true, completion: nil)
      }
    
    func checkNotificationStatusAndPrompt() {
        // Check notification settings
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    // Notifications are not allowed, prompt user to enable it
                    self.showNotificationAlert()
                }
            }
        }
    }

    func showNotificationAlert() {
        let alert = UIAlertController(
            title: "Notifications Disabled",
            message: "Enable notifications for SHARPXALLY Driver? Stay updated with ride requests, customer details, and important trip alerts to ensure seamless service.",
            preferredStyle: .alert
        )

      //  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            // Take the user to the app's settings
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
