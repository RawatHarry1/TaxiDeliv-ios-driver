//
//  VDHomeVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit
import GoogleMaps
import LGSideMenuController
import AVFAudio
import CoreLocation
import AVFoundation

var navigateToChatOnce = false
var navigateToChat = false

class VDHomeVC: VDBaseVC, SlideToActionButtonDelegate {
   
    @IBOutlet weak var rentalView: UIView!
    @IBOutlet weak var rentalTimeLbl: UILabel!
    @IBOutlet weak var lblRental: UILabel!
    // MARK: - Outlets
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    @IBOutlet weak private(set) var availabilityButton: UIButton!
    @IBOutlet weak var chattingBtn: UIButton!
    @IBOutlet weak var instructionsText: UILabel!
    @IBOutlet weak private(set) var offlineView: VDView!
    @IBOutlet weak private(set) var mapView: GMSMapView!
    @IBOutlet weak private(set) var newRideReqView: UIView!
    @IBOutlet weak private(set) var newRideReqDetails: UIView!
    @IBOutlet weak private(set) var cancelRideWhileProcess: VDButton!
    @IBOutlet weak private(set) var rideProcessingView: UIView!
    @IBOutlet weak var btnbottom: NSLayoutConstraint!
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
    
    @IBOutlet weak var viewInstructions: UIView!
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

    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var pickToOnTheWayLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var OntheWayToDestinationLbl: UILabel!

    @IBOutlet weak var lblHideShowStatus: UILabel!
    @IBOutlet weak var hideShowRideStatusView: UIView!
    @IBOutlet weak var btnCall: UIButton!
    // MARK: - Variables
   // var locationManager = CLLocationManager()
     var homeViewModel: VDHomeViewModel = VDHomeViewModel()
     var tripID: String?
    var customerID = ""
    var previousLocationSaved : CLLocation?
    var isUpdateOnce = true
    var muted = false
    var profileImg = ""
    var profileName = ""
    var markerUser : GMSMarker?
    var objDelivery_packages: [DeliveryPackageData]?
    var shouldUpdateCamera = true
    var mapTypeValue = 0
    var mapDetailValue = 0
    private var driverMarker = GMSMarker()
    private var currentMarker = GMSMarker()
    var phoneNo = ""
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
    var driverBearing = 0.0
    var currentLat = 0.0
    var currentLong = 0.0
    var cameraUpdateOnce = true
    var turnInitiated = false
    var coordinates = CLLocation()
    let speechSynthesizer = AVSpeechSynthesizer()
    var routeCoordinates:  [CLLocationCoordinate2D] = []
    var announcedSteps = Set<Int>()
    var isSpeaking: Bool = false
    var stepsModel: [Step] = []
    var selectedStepsModel : Step?
    var stepsModelDuplicate: [Step] = []
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
    var inaStep = false
    override func initialSetup() {
        callIndidLoad()
        callBacks()
       
      //  let obj = ClientModel.currentClientData
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    @IBOutlet weak var slideToActionBtn: SlideToActionButton!
    
    func showOnRideView()
    {
        self.btnChat.isHidden = false
        self.btnCall.isHidden = UserModel.currentUser.login?.service_type == 1 ? true : false
        self.hideShowRideStatusView.isHidden = false
        self.viewInstructions.isHidden = false
        self.btnSound.isHidden = false
        self.topView.isHidden = true
        heightTopView.constant = 0
        
    }
    func hideOnRideView()
    {
        self.btnChat.isHidden = true
        self.btnCall.isHidden = true
        self.hideShowRideStatusView.isHidden = true
        self.viewInstructions.isHidden = true
        self.btnSound.isHidden = true
        self.topView.isHidden = false
        heightTopView.constant = 44
    }
    var bestRouteText = ""
    @objc func appWillEnterForeground() {
        callIndidLoad()
    }
    
    func callIndidLoad(){
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Code to be executed after a delay
     // self.homeViewModel.fetchAvailableRide()
      //  }
        
    }
    
    @IBAction func btnSoundAct(_ sender: UIButton) {
        if muted == false
        {
            btnSound.setImage(UIImage(named: "mute"), for: .normal)
            muted = true
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        else
        {
            btnSound.setImage(UIImage(named: "sound"), for: .normal)
            muted = false

        }
    }
    @IBAction func btnCallAct(_ sender: UIButton) {
        guard let url = URL(string: "telprompt://\(phoneNo)"),
               UIApplication.shared.canOpenURL(url) else {
               return
           }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }
    func checkMapType(){
        
        self.mapTypeValue = UserDefaults.standard.value(forKey: "mapType") as? Int ?? 0
        self.mapDetailValue = UserDefaults.standard.value(forKey: "mapDetail") as? Int ?? 0
        if mapTypeValue == 1{
            self.mapView.mapType = .satellite
        }else if mapTypeValue == 2{
            self.mapView.mapType = .terrain
        }else{
            self.mapView.mapType = .normal
        }
   
        if mapDetailValue == 1{
            self.mapView.isTrafficEnabled = true
        }else{
            self.mapView.isTrafficEnabled = false
            self.mapView.mapType = .normal
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          // Restore default screen behavior
          UIApplication.shared.isIdleTimerDisabled = false
      }
    // Gesture recognizer handler
    var mapBottomInsets = 400
    
      @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
          if lblHideShowStatus.text! == ("View Map")
          {
              lblHideShowStatus.text = "Show Details"
              self.rideStatusView.isHidden = true
              self.btnbottom.constant = 20
              mapBottomInsets = 80
              let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: CGFloat(mapBottomInsets), right: 30)
              mapView.padding = mapInsets
              view.layoutIfNeeded()
          }
          else{
              lblHideShowStatus.text = "View Map"
              self.rideStatusView.isHidden = false
              self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
              mapBottomInsets = 400
              let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: CGFloat(mapBottomInsets), right: 30)
              mapView.padding = mapInsets
              view.layoutIfNeeded()
          }
          
      }
    var countMain = 0;
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        btnChat.setImage(UIImage(named: "msg")?.withRenderingMode(.alwaysTemplate), for: .normal)
        slideToActionBtn.delegate = self
        self.mapView.isMyLocationEnabled = false
        checkMapType()
        UIApplication.shared.isIdleTimerDisabled = true
        lblHideShowStatus.text = "View Map"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            self.view.addGestureRecognizer(tapGesture)
        self.hideShowRideStatusView.addGestureRecognizer(tapGesture)

        btnSound.addShadowViewOne()
        hideShowRideStatusView.addShadowViewOne()
        loginWithAccessToken()
    //  self.homeViewModel.fetchAvailableRide()
        checkLocationServices()
        checkNotificationStatusAndPrompt()
        let isDriverAvailablecheck = VDUserDefaults.value(forKey: .isDriverAvailable)
       
        let valueCheck = isDriverAvailablecheck.rawValue as? Bool
//        if valueCheck == false{
//            self.homeViewModel.changeDriverAvailability(0)
//           
//        }else{
//           
//            self.homeViewModel.changeDriverAvailability(1)
//        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let location = LocationTracker.shared.lastLocation {
                self.refreshMap(location)
            }
        }
       
        
        let isDriverAvailable = VDUserDefaults.value(forKey: .isDriverAvailable)
        if let value = isDriverAvailable.rawValue as? Bool {
            self.handleDriverAvailability(value)
        }
        if RideStatus == .none
        {
            self.mapView.clear()
        }
        if   RideStatus != .availableRide
                //&&  RideStatus != .rideCompleted
        {
        print(cancelRideBtn.title(for: .normal))
          self.homeViewModel.fetchAvailableRide()
      }
        if let notificationModel = sharedAppDelegate.notficationDetails {
            self.objDelivery_packages = notificationModel.delivery_packages
            
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

            } else if notificationModel.status == rideStatus.markArrived.rawValue || notificationModel.status == rideStatus.acceptedRide.rawValue || notificationModel.status == rideStatus.customerPickedUp.rawValue{
               if RideStatus != .rideCompleted
                {
                   homeViewModel.fetchAvailableRide()
                }
                
                updateUIAccordingtoRideStatus()
              
            }
          
            else {
               self.availabilityButton.isHidden = false
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
        rideStatusView.roundCorner([.topLeft, .topRight], radius: 30)
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
    func didFinishSliding() {
        slideToActionBtn.reset();
            if RideStatus == .none{
                self.availabilityButton.isHidden = false
            }else{
                self.availabilityButton.isHidden = true
            }
            if RideStatus == .acceptedRide {
                
    //            if UserModel.currentUser.login?.service_type == 1 {
                    
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
                    
    //            }else{
    //                let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
    //                let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
    //                vc.comesFromMardArrive = true
    //                vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
    //                vc.didPressContinue = {
    //                    if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
    //                        var att = [String:Any]()
    //                        att["tripId"] = tripID
    //                        att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""
    //
    //                        if let locationCreds = LocationTracker.shared.lastLocation {
    //                            att["pickupLongitude"] = locationCreds.coordinate.longitude
    //                            att["pickupLatitude"] = locationCreds.coordinate.latitude
    //                        }
    //                        self.homeViewModel.markArrivedTrip(att)
    //                    }
    //
    //                }
    //                self.navigationController?.pushViewController(vc, animated: true)
    //            }
                
                
           
            } else if RideStatus == .markArrived {
                if UserModel.currentUser.login?.service_type == 1 {
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
                }
                else
                {
                
                        let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
                    vc.driver_package_images = UserModel.currentUser.login?.services_config?[0].config?.driverPackageImages == 1

                        vc.comesFromMardArrive = true
                        vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
                        vc.didPressContinue = {
                            if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
                                var att = [String:Any]()
                                att["tripId"] = tripID
                                att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""
                                
                                if let locationCreds = LocationTracker.shared.lastLocation {
                                    att["pickupLongitude"] = locationCreds.coordinate.longitude
                                    att["pickupLatitude"] = locationCreds.coordinate.latitude
                                }
                                self.homeViewModel.startTrip(att)
                            }
                            
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                
            } else {
                if cancelRideBtn.title(for: .normal)! == "Reach Destination"
                {
                    cancelRideBtn.setTitle("Complete Trip", for: .normal)
                    slideToActionBtn.setLblText("Complete Trip")
                  //  Best Route
                    setCompleteLbl(string: "Complete Trip")
                    RideStatus = .rideCompleted
                   
                }
                else
                {
                    if UserModel.currentUser.login?.service_type == 1 {
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
                    }else{
                        let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
                        vc.driver_package_images = UserModel.currentUser.login?.services_config?[0].config?.driverPackageImages == 1

                        vc.comesFromMardArrive = false
                        vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
                        vc.didPressContinue = {
                            
                            var attributes = [String: Any]()
                            if let locationCreds = LocationTracker.shared.lastLocation {
                                attributes["dropLatitude"] = locationCreds.coordinate.latitude
                                attributes["dropLongitude"] = locationCreds.coordinate.longitude
                            }
                            attributes["customerId"] = sharedAppDelegate.notficationDetails?.customer_id
                            attributes["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
                            attributes["rideTime"] = 12
                            attributes["waitTime"] = 3
                            self.homeViewModel.endRideApi(attributes)
                            
                            
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
               
            }
        }
    
    @objc func cancelRideOnSwipe() {
        if RideStatus == .none{
            self.availabilityButton.isHidden = false
        }else{
            self.availabilityButton.isHidden = true
        }
        if RideStatus == .acceptedRide {
            
//            if UserModel.currentUser.login?.service_type == 1 {
                
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
                
//            }else{
//                let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
//                vc.comesFromMardArrive = true
//                vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
//                vc.didPressContinue = {
//                    if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
//                        var att = [String:Any]()
//                        att["tripId"] = tripID
//                        att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""
//
//                        if let locationCreds = LocationTracker.shared.lastLocation {
//                            att["pickupLongitude"] = locationCreds.coordinate.longitude
//                            att["pickupLatitude"] = locationCreds.coordinate.latitude
//                        }
//                        self.homeViewModel.markArrivedTrip(att)
//                    }
//
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
       
        } else if RideStatus == .markArrived {
            if UserModel.currentUser.login?.service_type == 1 {
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
            }
            else
            {
            
                    let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
                    vc.comesFromMardArrive = true
                    vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
                    vc.didPressContinue = {
                        if let tripID = sharedAppDelegate.notficationDetails?.trip_id  {
                            var att = [String:Any]()
                            att["tripId"] = tripID
                            att["customerId"] = sharedAppDelegate.notficationDetails?.customer_id ?? ""
                            
                            if let locationCreds = LocationTracker.shared.lastLocation {
                                att["pickupLongitude"] = locationCreds.coordinate.longitude
                                att["pickupLatitude"] = locationCreds.coordinate.latitude
                            }
                            self.homeViewModel.startTrip(att)
                        }
                        
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            
            
        } else {
            if cancelRideBtn.title(for: .normal)! == "Reach Destination"
            {
                cancelRideBtn.setTitle("Complete Trip", for: .normal)
                slideToActionBtn.setLblText("Complete Trip")
              //  Best Route
                setCompleteLbl(string: "Complete Trip")
                RideStatus = .rideCompleted
               
            }
            else
            {
                if UserModel.currentUser.login?.service_type == 1 {
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
                }else{
                    let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PackageListVC") as!  PackageListVC
                    vc.comesFromMardArrive = false
                    vc.deliveryPackages = self.homeViewModel.objFetchOngoingModal?.deliveryPackages
                    vc.didPressContinue = {
                        
                        var attributes = [String: Any]()
                        if let locationCreds = LocationTracker.shared.lastLocation {
                            attributes["dropLatitude"] = locationCreds.coordinate.latitude
                            attributes["dropLongitude"] = locationCreds.coordinate.longitude
                        }
                        attributes["customerId"] = sharedAppDelegate.notficationDetails?.customer_id
                        attributes["tripId"] = sharedAppDelegate.notficationDetails?.trip_id
                        attributes["rideTime"] = 12
                        attributes["waitTime"] = 3
                        self.homeViewModel.endRideApi(attributes)
                        
                        
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
           
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
            self.availabilityButton.setImage(self.availabilityButton.image(for: .selected)?.withRenderingMode(.alwaysTemplate), for: .selected)
            self.offlineView.isHidden = true
            self.titleLbl.text = "Online"
            
        } else {
            VDUserDefaults.save(value: false, forKey: .isDriverAvailable)
            self.availabilityButton.isSelected = false
            self.offlineView.isHidden = docPendingView.isHidden == false ? true : false
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
            self.hideOnRideView()
            self.btnbottom.constant = 20
            btnChat.isHidden = true
            self.availabilityButton.isHidden = false
            
            self.mapView.clear()
//            stopTimer() // Stop timer to update driver location when driver is not taking any rides
        case .availableRide :
            newRideReqView.isHidden = false
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = true
            self.hideOnRideView()
            self.btnbottom.constant = 20
            updateAvailableRidePopUp()
        case .acceptedRide :
           // Write code for driver is in proress to pick up driver
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            self.showOnRideView()
            self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
            cancelRideBtn.setTitle("Slide to Mark Arrived", for: .normal)
            slideToActionBtn.setLblText("Slide to Mark Arrived")
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
            self.showOnRideView()
            self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
            if UserModel.currentUser.login?.service_type != 1 {
                cancelRideBtn.setTitle("Slide to start delivery", for: .normal)
                slideToActionBtn.setLblText("Slide to start delivery")
            }
            else{
                cancelRideBtn.setTitle("Slide to Start Trip", for: .normal)
                slideToActionBtn.setLblText("Slide to Start Trip")

            }

        case .customerPickedUp :

            printDebug("Customer picked up")
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            self.showOnRideView()
            self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
//            if UserModel.currentUser.login?.service_type == 1 {
//                cancelRideBtn.setTitle("Slide to Complete Trip", for: .normal)
//            }
//            else
//            {
                cancelRideBtn.setTitle("Reach Destination", for: .normal)
            slideToActionBtn.setLblText("Reach Destination")

//            }
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
            
        case .rideCompleted :
            newRideReqView.isHidden = true
            rideProcessingView.isHidden = true
            rideStatusView.isHidden = false
            self.showOnRideView()
            self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
            cancelRideBtn.setTitle("Complete Trip", for: .normal)
            slideToActionBtn.setLblText("Complete Trip")
            btnChat.isHidden = false
        default:
           
            self.availabilityButton.isUserInteractionEnabled = true
            break
        }
    }

    func updateOngoingRideStatusPopUp() {
        if RideStatus == .acceptedRide {
          //  completRideLbl.text = "Ride Accepted"

            arrivedRadioImg.image = VDImageAsset.radioDisable.asset
            onTheWayRadioImg.image = VDImageAsset.radioDisable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textFieldBorder.color
            ontheWayDestinationLbl.textColor = VDColors.textFieldBorder.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.textFieldBorder.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        } else if RideStatus == .markArrived {
          //  completRideLbl.text = "Marked Arrived"
            setCompleteLbl()
            arrivedRadioImg.image = VDImageAsset.radioEnable.asset
            onTheWayRadioImg.image = VDImageAsset.radioDisable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textColor.color
            ontheWayDestinationLbl.textColor = VDColors.textFieldBorder.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.textFieldBorder.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        } else if RideStatus == .customerPickedUp {
           // completRideLbl.text = "Trip Started"
            arrivedRadioImg.image = VDImageAsset.radioEnable.asset
            onTheWayRadioImg.image = VDImageAsset.radioEnable.asset
            radioDestinationImg.image = VDImageAsset.radioDisable.asset

            arrivedStatusLbl.textColor = VDColors.textColor.color
            ontheWayDestinationLbl.textColor = VDColors.textColor.color
            completeRideLbl.textColor = VDColors.textFieldBorder.color

            pickToOnTheWayLbl.backgroundColor = VDColors.buttonSelectedOrange.color
            OntheWayToDestinationLbl.backgroundColor = VDColors.textFieldBorder.color
        }
        if UserModel.currentUser.login?.service_type == 1 {
            
            completeRideLbl.text = "Mars Driver Ride Completed"
        }
        else
        {
            completeRideLbl.text = "Mars Driver Delivery Completed"

        }

    }

    func showVarifyDocumentsPopUp() {
        let vc = VDDocumentVerificationVC.create()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }

    func updateAvailableRidePopUp() {
        if let notificationModel = sharedAppDelegate.notficationDetails {
        //    self.objDelivery_packages = notificationModel.delivery_packages
            tripID = notificationModel.trip_id
            customerID = notificationModel.customer_id ?? ""
            profileImg = notificationModel.customer_image ?? ""
            profileName = notificationModel.customer_name ?? ""
            if notificationModel.status == notificationTypes.new_ride_request.rawValue {
                if let urlStr = notificationModel.customer_image {
                    self.customerProfileImg.sd_setImage(with: URL(string: urlStr), placeholderImage: VDImageAsset.imgPlaceholder.asset, options: [.refreshCached, .highPriority], completed: nil)
//                    self.customerProfileImg.setImage(withUrl: urlStr) { status, image in
//                        if status {
//                            if let img = image {
//                                self.customerProfileImg.image = img
//                            }
//                        }
//                    }
                } else {
                    self.customerProfileImg.image = VDImageAsset.imgPlaceholder.asset
                }

                self.customerNameLbl.text = notificationModel.customer_name ?? ""
              if  notificationModel.is_for_rental == 1{
                  self.lblRental.isHidden = false
                  self.rentalView.isHidden = false
                  self.rentalTimeLbl.text = formatDateString(notificationModel.rental_drop_date ?? "")

                }
                else
                {
                    self.lblRental.isHidden = true
                       self.rentalView.isHidden = true

                }
                
                
                if let estimatedFare = notificationModel.estimated_driver_fare,
                   let currency = notificationModel.currency{
                   if estimatedFare.contains(currency) {
                        print("Estimated Fare" + estimatedFare)
                        // Do something when estimated fare contains the currency
                        self.amountLbl.text = "\(notificationModel.estimated_driver_fare ?? "")"
                    } else {
                        print("Estimated Fare" + estimatedFare)
                        self.amountLbl.text = "\(notificationModel.currency ?? "")\(estimatedFare ?? "")"
                        // Do something else if it doesn't contain the currency
                    }
                }
                
                
                var distance =  notificationModel.estimated_distance ?? ""
             //   if notificationModel.distanceUnit ?? "" != ""{
                //    self.distanceLbl.text = "\(distance ?? "")\(notificationModel.distanceUnit ?? "")"
               // }else{
                
                self.distanceLbl.text = "\(distance) " + "\(notificationModel.distanceUnit ?? "")"
                //}
                
                self.pickUpLocationLbl.text = notificationModel.pickup_address ?? ""
                self.dropLocationLbl.text = notificationModel.drop_address ?? ""
            }
        }
    }
    func formatDateString(_ dateString: String) -> String? {
        // Define the input format (ISO 8601 format)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // Convert the string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            
            // Define the output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEE, MMM dd hh:mm a"
            outputFormatter.locale = Locale(identifier: "en_US") // Ensure English locale
            
            // Convert the Date object to the desired format
            return outputFormatter.string(from: date)
        }
        return nil
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
        offlineView.isHidden = true
        
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
            currentUser.passcode = UserModel.currentUser.passcode
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
            self.showOnRideView()
            self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
          
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
            obj.objDelivery_packages = self.objDelivery_packages ?? []
            obj.endRideModel = endRideStatus
           
            obj.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(obj, animated: true)
            //present(obj, animated: true)
        }
        
        // TODO: - Draw polyline callback
        //
        homeViewModel.polylineCallBack = { polyline in
            self.turnInitiated = false
            self.inaStep = false
            self.selectedStepsModel = nil

            self.polyLinePath = polyline
            self.drawpolyLineForRide(polyline)
            // self.showPath(polyStr: polyline)
        }
        homeViewModel.legsCallBack = { legs in
            // Safely unwrap the first leg, and its duration and distance properties
            guard let firstLeg = legs.first else { return }
            
            // Safely extract duration and distance text, using nil coalescing for fallback
            let durationText = ((firstLeg["duration"] as? NSDictionary)?["text"] as? String) ?? ""
            let distanceText = ((firstLeg["distance"] as? NSDictionary)?["text"] as? String) ?? ""
            
            // Construct the final string
            self.bestRouteText = "Best Route (\(durationText)) \(distanceText)"
            
            if RideStatus == .rideCompleted
            {
            self.setCompleteLbl(string: "Complete Trip")
            }
            else
            {
                self.setCompleteLbl()
            }
            
            
            // Extract steps from the first leg
            if let stepsArray = firstLeg["steps"] as? [[String: Any]] {
                // Parse the steps array into an array of Step objects (you can convert it to a model if needed)
                self.stepsModel = []
                for stepDict in stepsArray {
                    if let step = self.parseStep(from: stepDict) {
                        self.stepsModel.append(step)
                    }
                }
            }
            self.stepsModelDuplicate =  self.stepsModel
            print(self.stepsModel.count)
            self.setUpStepsView()
        }
        
    }
    
    func setUpStepsView()
    {
        setPlainTextFromHTML(htmlString: self.stepsModelDuplicate[0].htmlInstructions, label: self.instructionsText)
     
    }
    func setPlainTextFromHTML(htmlString: String, label: UILabel) {
        guard let data = htmlString.data(using: .unicode) else {
            return
        }
        
        do {
            // Create an attributed string from the HTML string
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            
            // Extract plain text from the attributed string (by just using the string property)
            let plainText = attributedString.string
            
            // Set the plain text to the label
            label.text = plainText
            
        } catch {
            print("Error creating attributed string from HTML: \(error)")
        }
    }
    // Example parsing function to convert a dictionary into a Step model
    func parseStep(from dictionary: [String: Any]) -> Step? {
        guard let distanceDict = dictionary["distance"] as? [String: Any],
              let durationDict = dictionary["duration"] as? [String: Any],
              let endLocationDict = dictionary["end_location"] as? [String: Any],
              let startLocationDict = dictionary["start_location"] as? [String: Any],
              let polylineDict = dictionary["polyline"] as? [String: Any] else {
            return nil
        }
        
        let distanceText = distanceDict["text"] as? String ?? ""
        let distanceValue = distanceDict["value"] as? Int ?? 0
        let durationText = durationDict["text"] as? String ?? ""
        let durationValue = durationDict["value"] as? Int ?? 0
        let lat = endLocationDict["lat"] as? Double
        let lng = endLocationDict["lng"] as? Double
        let startLat = startLocationDict["lat"] as? Double
        let startLng = startLocationDict["lng"] as? Double
        let polylinePoints = polylineDict["points"] as? String ?? ""
        let htmlInstructions = dictionary["html_instructions"] as? String ?? ""
        let maneuver = dictionary["maneuver"] as? String
        
        let distance = Distance(text: distanceText, value: distanceValue)
        let duration = Duration(text: durationText, value: durationValue)
        let endLocation = Location(lat: lat, lng: lng)
        let startLocation = Location(lat: startLat, lng: startLng)
        let polyline = Polyline(points: polylinePoints)
        let travelMode = TravelMode(rawValue: dictionary["travel_mode"] as? String ?? "") ?? .driving
        
        return SaloneRide.Step(distance: distance, duration: duration, endLocation: endLocation, htmlInstructions: htmlInstructions, polyline: polyline, startLocation: startLocation, travelMode: travelMode, maneuver: maneuver)
    }
    func setCompleteLbl(string : String? = "Best Route")
    {
        // Create an NSMutableAttributedString from the full text
       
            self.bestRouteText = self.bestRouteText.replacing("Best Route", with: string!)

        
        let attributedString = NSMutableAttributedString(string: self.bestRouteText)

          // Find the range of "Best Route" to apply bold
        let bestRouteRange = (self.bestRouteText as NSString).range(of: string!)

          // Apply bold font style to "Best Route"
          attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: bestRouteRange)

          // Apply regular font style to the rest of the text (duration and distance)
        let restOfTextRange = NSRange(location: bestRouteRange.location + bestRouteRange.length, length: self.bestRouteText.count - bestRouteRange.length)
          attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: restOfTextRange)
          self.completRideLbl.attributedText = attributedString
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
            self.phoneNo = notification.recipient_phone_no ?? ""
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
                self.showOnRideView()
                self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
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
                self.showOnRideView()
                self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
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
                if let notificationModel = sharedAppDelegate.notficationDetails {
                    let obj = VDRideCompleteVC.instantiate(fromAppStoryboard: .postLogin)
                    obj.screenTyoe = 1
                    obj.dateRentalDrop = self.formatDateString(notificationModel.rental_drop_date ?? "") ?? ""
                    obj.isRental = notificationModel.is_for_rental == 1 ? true : false
                    obj.objDelivery_packages = self.objDelivery_packages ?? []
                    //let obj = VDRideCompleteVC.create(1)
                    obj.modalPresentationStyle = .overFullScreen
                    obj.markArrived = { status  in
                        self.updateUIAccordingtoRideStatus()
                    }
                    self.navigationController?.pushViewController(obj, animated: true)
                }
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
       // self.homeViewModel.fetchAvailableRide()
    }

    @IBAction func btnCancelRideProcessing(_ sender: UIButton) {
       
        rideProcessingView.isHidden = true
        rideStatusView.isHidden = false
        self.showOnRideView()
        self.btnbottom.constant = UserModel.currentUser.login?.service_type == 1 ? 300  : 350
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
//        if let location = LocationTracker.shared.lastLocation {
//            self.refreshMap(location)
//
//        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapSettingsVC") as! MapSettingsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.mapDetailval = mapDetailValue
        vc.mapTypeVal = mapTypeValue
        vc.didSelectMapType = { mapType in
            self.mapTypeValue = mapType
            
            if mapType == 1{
                self.mapView.mapType = .satellite
            }else if mapType == 2{
                self.mapView.mapType = .terrain
            }else{
                self.mapView.mapType = .normal
            }
        }
        vc.didSelectMapDetail = { mapDetail in
            self.mapDetailValue = mapDetail
            
            if mapDetail == 1{
                self.mapView.isTrafficEnabled = true
            }else{
                self.mapView.isTrafficEnabled = false
              
            }
        }
        self.present(vc, animated: true)
    }
}



// MARK: - Update Driver Location using timer
extension VDHomeVC {

    // Function to start the timer
    private func startTimerToUpdateDriverLocation() {
            self.stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.timerToUpdateDriverLocation = Timer.scheduledTimer(timeInterval: self.timerIntervalToRefersh, target: self, selector: #selector(self.apiCallforRefreshNearbyDriver(_ :)), userInfo: nil, repeats: true)
        }
    }

    private func stopTimer() {
        timerToUpdateDriverLocation?.invalidate()
        timerToUpdateDriverLocation = nil
    }
    // Step 1: Function to check if the current location is within bounds of a given step
    // Step 1: Calculate the distance between two locations
    func distanceBetween(_ location1: CLLocation, _ location2: CLLocation) -> CLLocationDistance {
        return location1.distance(from: location2)
    }
    func bearing(from start: CLLocation, to end: CLLocation) -> Double {
        let startLatitude = start.coordinate.latitude
        let startLongitude = start.coordinate.longitude
        let endLatitude = end.coordinate.latitude
        let endLongitude = end.coordinate.longitude

        let deltaLongitude = endLongitude - startLongitude

        let y = sin(deltaLongitude) * cos(endLatitude)
        let x = cos(startLatitude) * sin(endLatitude) - sin(startLatitude) * cos(endLatitude) * cos(deltaLongitude)
        let bearing = atan2(y, x)

        return bearing * 180 / .pi // Convert from radians to degrees
    }
    // Step 2: Check if the current location is within a reasonable proximity to the route (between start and end locations)
    func isCurrentLocationBetween(startLocation: CLLocation, endLocation: CLLocation, currentLocation: CLLocation, tolerance: CLLocationDistance = 50) -> Bool {
        // Get the bearing between the start and end points
        let bearingStartToEnd = bearing(from: startLocation, to: endLocation)
        
        // Get the distance between the current location and the start location
        let distanceToStart = distanceBetween(currentLocation, startLocation)
        let distanceToEnd = distanceBetween(currentLocation, endLocation)

        // Check if the current location is within the tolerance distance of the line between the two points
        let maxDistance = max(distanceToStart, distanceToEnd)
        
        // Ensure the current location is within the bounding box (between start and end)
        // We check if the distance to the start and the distance to the end are approximately in the right range
        if distanceToStart <= maxDistance && distanceToEnd <= maxDistance {
            // If within tolerance distance, consider the location between the two points
            return distanceToStart <= maxDistance + tolerance && distanceToEnd <= maxDistance + tolerance
        }
        
        return false
    }
    func isCurrentLocationWithinBounds(currentLocation: CLLocation, step: Step) -> Bool {
        guard let startLatitude =  step.startLocation.lat,
              let startLongitude = step.startLocation.lng,
              let endLatitude = step.endLocation.lat ,
              let endLongitude = step.endLocation.lng else {
            return false
        }

        // Convert start and end locations into CLLocation
        let startLocation = CLLocation(latitude: startLatitude, longitude: startLongitude)
        let endLocation = CLLocation(latitude: endLatitude, longitude: endLongitude)

        // Check if current location is between start and end location latitudes and longitudes
        let isLatitudeInRange = currentLocation.coordinate.latitude >= min(startLatitude, endLatitude) &&
                                currentLocation.coordinate.latitude <= max(startLatitude, endLatitude)
        
        let isLongitudeInRange = currentLocation.coordinate.longitude >= min(startLongitude, endLongitude) &&
                                 currentLocation.coordinate.longitude <= max(startLongitude, endLongitude)

        return isLatitudeInRange && isLongitudeInRange
    }
    
    

    // Step 2: Function to update the label when reaching the instruction step
    func updateInstructionLabelForCurrentLocation(currentLocation: CLLocation, steps: [Step]) {
        // 1. Check if the user is between the start and end of the current step
        if self.inaStep == false {
            for step in steps {
                if distanceBetween(
                    CLLocation(latitude: CLLocationDegrees(step.startLocation.lat ?? 0.0),
                              longitude: CLLocationDegrees(step.startLocation.lng ?? 0.0)),
                    currentLocation
                ) <= 50 {
                    self.inaStep = true
                    self.selectedStepsModel = step
                    print("You are between the start and end points." + step.htmlInstructions)
                    self.setPlainTextFromHTML(htmlString: step.htmlInstructions, label: self.instructionsText)
                } else {
                    print("You are not between the start and end points.")
                }
            }
        }

        // 2. Turn initiation and progress
        if self.inaStep == true {
            // Check if the user is within 100 meters of the step's end location to give turn instructions
            print(distanceBetween(
                CLLocation(latitude: CLLocationDegrees(self.selectedStepsModel?.endLocation.lat ?? 0.0),
                          longitude: CLLocationDegrees(self.selectedStepsModel?.endLocation.lng ?? 0.0)),
                currentLocation
            ))
            
            if distanceBetween(
                CLLocation(latitude: CLLocationDegrees(self.selectedStepsModel?.endLocation.lat ?? 0.0),
                          longitude: CLLocationDegrees(self.selectedStepsModel?.endLocation.lng ?? 0.0)),
                currentLocation
            ) <= 100 {
                turnInitiated = true
                
                // Give speech instructions based on maneuver
               
             
            }

            // 3. After the turn is initiated, check for turn completion
                if turnInitiated == true {
                    
                    // Get the current heading (course) from the user's location (in degrees)
                    let userHeading = currentLocation.course

                    // Now, calculate the expected heading based on the maneuver ("turn-right" or "turn-left")
                    var expectedHeading: Double?

                    if let maneuver = self.selectedStepsModel?.maneuver {
                        switch maneuver {
                        case "turn-right":
                            // A right turn usually means a 90-degree turn clockwise
                            expectedHeading = userHeading + 90
                            
                        case "turn-left":
                            // A left turn usually means a 90-degree turn counterclockwise
                            expectedHeading = userHeading - 90
                            
                        default:
                            // If no turn is specified, the expected heading is just the current heading
                            expectedHeading = userHeading
                        }
                        
                        // Ensure the expectedHeading stays within the range of 0-360 degrees
                        if expectedHeading! >= 360 {
                            expectedHeading! -= 360
                        } else if expectedHeading! < 0 {
                            expectedHeading! += 360
                        }
                    }

                    // Now that we have calculated the expected heading, you can compare it to the user's current heading
                    if let expectedHeading = expectedHeading {
                        // Define a tolerance range (e.g., 20 degrees) for completing the turn
                        let headingDifference = abs(userHeading - expectedHeading)
                        
                        if headingDifference < 20 { // 20-degree tolerance for completing the turn
                            print("Turn completed!")
                            turnInitiated = false
                            self.inaStep = false
                            self.selectedStepsModel = nil
                        }
                    }

                }
        }
    }
    @objc private func apiCallforRefreshNearbyDriver(_ timer: TimeInterval) {
       // SKToast.show(withMessage: "Refresh")
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
                self.updateInstructionLabelForCurrentLocation(currentLocation: currentLocation, steps: self.stepsModel)
//
//              if previousLocationSaved != nil
//                {
//                  if (currentLocation.distance(from: previousLocationSaved!) < 10)
//                  {
//                      return
//                  }
//              }
//                    
//                    
//                    previousLocationSaved = currentLocation;
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
                
                //                if RideStatus != .none{
                //                    for (index, coordinate) in routeCoordinates.enumerated() {
                //                            let pointLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                //                            let distance = currentLocation.distance(from: pointLocation)
                //
                //                            if distance <= 100 && !announcedSteps.contains(index) { // Announce within 100 meters
                //                                announceTurn(at: index)
                //                                announcedSteps.insert(index)
                //                            }
                //                        }
                //                }
                
                
                
                if (RideStatus == .markArrived) || (RideStatus == .acceptedRide) {
                    // fallback
                } else {
                    destination = CLLocationCoordinate2D(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
                }
                
                var source = CLLocation(latitude: (trips.drop_latitude ?? "0.0").double ?? 0.0, longitude: (trips.drop_longitude ?? "0.0").double ?? 0.0)
                
                
                //   let driverBearing = self.calculateBearing(from: currentLocation.coordinate, to: destination)
                DispatchQueue.main.async {
                    self.getTurnInstructions()
                    //self.showMarker(Source: source.coordinate, Destination: destination)
                    self.updateMarkersPositionForRide(self.driverBearing,currentLocation.coordinate , destination, true)
                }
                
                VDUserDefaults.save(value: [(trips.drop_latitude ?? "0.0").double ?? 0.0, (trips.drop_longitude ?? "0.0").double ?? 0.0, 0.0], forKey: .currentLocation)
                
                //                } else {
                //                    return
                //                }
                
             }else {
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
    
    func calculateBearing2(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = start.latitude.degreesToRadians
        let lon1 = start.longitude.degreesToRadians
        let lat2 = end.latitude.degreesToRadians
        let lon2 = end.longitude.degreesToRadians
        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        // Convert bearing from radians to degrees and normalize to 0-360 range
        let bearing = radiansBearing.radiansToDegrees
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }
    
    
    func calculateBearing(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = startLocation.latitude.degreesToRadians
        let lon1 = startLocation.longitude.degreesToRadians
        let lat2 = endLocation.latitude.degreesToRadians
        let lon2 = endLocation.longitude.degreesToRadians
        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        // Convert bearing from radians to degrees and normalize to 0-360 range
        let bearing = radiansBearing.radiansToDegrees
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
//        let lat1 = startLocation.latitude.toRadians()
//        let lon1 = startLocation.longitude.toRadians()
//        
//        let lat2 = endLocation.latitude.toRadians()
//        let lon2 = endLocation.longitude.toRadians()
//        
//        let deltaLongitude = lon2 - lon1
//        let y = sin(deltaLongitude) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude)
//        
//        let initialBearing = atan2(y, x).toDegrees()
//        return (initialBearing + 360).truncatingRemainder(dividingBy: 360)
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
            self.homeViewModel.getNewPolyline("\(driverCord)","\(locCord)")
           // let driverBearing = self.calculateBearing(from: latestCoordinates, to: destination)
            self.updateMarkersPositionForRide(self.driverBearing, latestCoordinates, destination, false , shouldUpdateCameraMovement)
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
        
        let mapInsets = UIEdgeInsets(top: 150, left: 30, bottom: CGFloat(mapBottomInsets), right: 30)
        mapView.padding = mapInsets
        view.layoutIfNeeded()
        
      //  monitorTurnDirections(currentLocation: LocationTracker.shared.lastLocation?.coordinate ?? CLLocationCoordinate2D(), path: self.routeCoordinates)
        
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
            driverMarker.isFlat = true
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
            currentMarker.isFlat = true
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
        driverMarker.isFlat = true
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
        
//        guard let nextCoordinate = getNextPolylineCoordinate(currentCoordinates: LocationTracker.shared.lastLocation?.coordinate ?? CLLocationCoordinate2D(), polylineCoordinates: routeCoordinates) else {
//            return
//        }
        
        let coordinateCount = gmsPath.count()
       
        // Ensure there are at least 3 coordinates before trying to iterate
        if coordinateCount > 2 {
            for i in 0..<(coordinateCount - 2) {
                let currentLocation = gmsPath.coordinate(at: i)
                let encodedPolyline = polyLinePoints
                if let routeCoordinates = decodePolyline(encodedPolyline) {
                    print("Route Coordinates: \(routeCoordinates)")
                    self.routeCoordinates = routeCoordinates
                }
            }
        } else {
            print("Not enough coordinates to process.")
        }



       

        // Output bearings
   
//                let nextLocation = gmsPath.coordinate(at: i + 1)
//                let afterNextLocation = gmsPath.coordinate(at: i + 2)
//                
//                // Calculate turn direction
//                let direction = getTurnDirection(
//                    currentLocation: currentLocation,
//                    nextLocation: nextLocation,
//                    afterNextLocation: afterNextLocation
//                )
//            routeCoordinates.append(direction)
//            }
//        for (index, direction) in routeCoordinates.enumerated() {
//                print("At segment \(index + 1): \(direction)")
//            }
        
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
    
    func getTurnInstructions(){
        if (routeCoordinates.count > 0)
        {
            for i in 0..<routeCoordinates.count - 2 {
            let currentLocation = routeCoordinates[i]
            let nextLocation = routeCoordinates[i + 1]
            let afterNextLocation = routeCoordinates[i + 2]
            
            let bearing = calculateBearing(from: LocationTracker.shared.lastLocation?.coordinate ?? CLLocationCoordinate2D(), to: nextLocation)
            
            self.driverBearing = bearing
            
            // Calculate the distance from the user's location to the next turn
            let nextTurnLocation = CLLocation(latitude: nextLocation.latitude, longitude: nextLocation.longitude)
            let  userLocation = CLLocation(latitude: LocationTracker.shared.lastLocation?.coordinate.latitude ?? 0, longitude: LocationTracker.shared.lastLocation?.coordinate.longitude ?? 0)
            let distanceToNextTurn = userLocation.distance(from: nextTurnLocation)
            
            // Check if the user is within 50 meters of the next turn
            if distanceToNextTurn <= 100 {
                // Calculate the bearing for each consecutive pair of points
                let bearing1 = calculateBearing(from: currentLocation, to: nextLocation)
                let bearing2 = calculateBearing(from: nextLocation, to: afterNextLocation)
                
                // Calculate the difference between the two bearings
                let angleDifference = bearing2 - bearing1
                speechSynthesizer.stopSpeaking(at: .immediate)
                // Determine if it's a left or right turn or continue straight
                if angleDifference > 15 && angleDifference < 180 {
                    giveSpeechInstruction("Turn right")
                } else if angleDifference < -15 && angleDifference > -180 {
                    giveSpeechInstruction("Turn left")
                } else {
                 // giveSpeechInstruction("Continue straight")
                }
            }
        }
        }
    }
    
    
    func checkTurnProgress(_ nextTurnLocation: CLLocation) {
        if let lastLocation = LocationTracker.shared.lastLocation {
            let userLocation = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            // Now you can use userLocation
        }
      //  let distanceToNextTurn = userLocation.distance(from: nextTurnLocation)
        guard let userLocation = lastLocation else { return }
            // Check if the user is still within 50 meters of the turn
            let distanceToNextTurn = userLocation.distance(from: nextTurnLocation)
            if distanceToNextTurn <= 50 {
                // Keep speaking the instruction until the user turns
                if !isSpeaking {
                    self.getTurnInstructions() // Recheck and speak the instruction again
                }
            } else {
                // User has passed the turn, stop the speech
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
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
            message: "Enable notifications for Mars Driver Driver? Stay updated with ride requests, customer details, and important trip alerts to ensure seamless service.",
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
    
    
    // TODO: - Login with access token
    private func loginWithAccessToken() {
        if let _ = LocationTracker.shared.lastLocation {
        } else {
            failedToFetchLocation = true
            SKToast.show(withMessage: "Not able to fetch your location")
            return
        }
        var paramToModifyVehicleDetails: JSONDictionary {
            if let location = LocationTracker.shared.lastLocation {
                let param = [
                    "latitude": location.coordinate.latitude ,
                    "longitude": location.coordinate.longitude
                ] as [String: Any]
                return param
            } else {
                return [String:Any]()
            }
        }
        
        WebServices.loginWithAccessToken(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let _):
             
                self?.handleValidationPopUp()
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
extension VDHomeVC{

    func monitorTurnDirections(currentLocation: CLLocationCoordinate2D, path: [CLLocationCoordinate2D]) {
        guard path.count > 2 else { return }
        
        for i in 0..<(path.count - 2) {
            let nextLocation = path[i + 1]
            let afterNextLocation = path[i + 2]
            
            // Calculate distance to the next location
            let distance = calculateBearing2(from: currentLocation, to: nextLocation)
            
            // Announce turn only when within 100 meters
            if distance <= 100 {
                let direction = getTurnDirection(currentLocation: currentLocation, nextLocation: nextLocation, afterNextLocation: afterNextLocation)
                announceDirection(direction)
            }
        }
    }

    // Helper Method: Calculate distance between two coordinates
    func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2) // Distance in meters
    }
    
    func getTurnDirection(currentLocation: CLLocationCoordinate2D, nextLocation: CLLocationCoordinate2D, afterNextLocation: CLLocationCoordinate2D) -> String {
        // Calculate bearing from current location to next location
      //  let nextCoordinate = getNextPolylineCoordinate(currentCoordinates: currentLocation, polylineCoordinates: self.routeCoordinates) ?? <#default value#>
        let bearing1 = calculateBearing2(from: currentLocation, to: nextLocation)
       // driverBearing = bearing1
        // Calculate bearing from next location to after-next location
        let bearing2 = calculateBearing2(from: nextLocation, to: afterNextLocation)
        
        // Calculate the angle difference
        let angleDifference = bearing2 - bearing1
        
        if angleDifference > 15 && angleDifference < 180 {
       
            return "Turn right"
        } else if angleDifference < -15 && angleDifference > -180 {
       
            return "Turn left"
        } else {

            return "Continue straight"
        }
    }
    
//    func getBearingsFromPolylineCoordinates(polylineCoordinates: [CLLocationCoordinate2D]) -> [Double] {
//        var bearings = [Double]()
//        
//        for i in 0..<polylineCoordinates.count - 1 {
//            let bearing = calculateBearing(from: polylineCoordinates[i], to: polylineCoordinates[i + 1])
//            bearings.append(bearing)
//        }
//        
//        return bearings
//    }
    
    func announceDirection(_ direction: String) {
        // Use text-to-speech or another mechanism to announce the direction
        print(direction)
        
        let utterance = AVSpeechUtterance(string: direction)
          utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
          utterance.rate = 0.5
        if muted == false{
            if !speechSynthesizer.isSpeaking {
                speechSynthesizer.speak(utterance)
            }
        }
    }
    
    func getNextPolylineCoordinate(currentCoordinates: CLLocationCoordinate2D, polylineCoordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        // Find the next coordinate in the polyline relative to the current coordinates.
        // Implement a more sophisticated approach if needed.
        let closestPoint = polylineCoordinates.min {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: CLLocation(latitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude)) <
            CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: CLLocation(latitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude))
        }
        return closestPoint
    }
    
    func getPolylineCoordinates(from polyline: GMSPolyline) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        // Ensure the polyline has a path
        guard let path = polyline.path else {
            print("No path found in polyline")
            return coordinates
        }
        
        // Iterate through the path and append coordinates
        for index in 0..<path.count() {
            let coordinate = path.coordinate(at: index)
            coordinates.append(coordinate)
        }
        
        return coordinates
    }
    
    func giveSpeechInstruction(_ instruction: String) {
        if muted == false{
            let speechUtterance = AVSpeechUtterance(string: instruction)
            speechSynthesizer.speak(speechUtterance)
        isSpeaking = true

        }
        }
    
    func decodePolyline(_ encodedPolyline: String) -> [CLLocationCoordinate2D]? {
        var coordinates: [CLLocationCoordinate2D] = []
        var index = encodedPolyline.startIndex
        let length = encodedPolyline.count
        var lat = 0
        var lng = 0

        while index < encodedPolyline.endIndex {
            var b: Int
            var shift = 0
            var result = 0

            repeat {
                b = Int(encodedPolyline[index].asciiValue! - 63)
                index = encodedPolyline.index(after: index)
                result |= (b & 0x1F) << shift
                shift += 5
            } while b >= 0x20
            let deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            lat += deltaLat

            shift = 0
            result = 0

            repeat {
                b = Int(encodedPolyline[index].asciiValue! - 63)
                index = encodedPolyline.index(after: index)
                result |= (b & 0x1F) << shift
                shift += 5
            } while b >= 0x20
            let deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            lng += deltaLng

            coordinates.append(CLLocationCoordinate2D(latitude: Double(lat) / 1E5, longitude: Double(lng) / 1E5))
        }

        return coordinates
    }

}
