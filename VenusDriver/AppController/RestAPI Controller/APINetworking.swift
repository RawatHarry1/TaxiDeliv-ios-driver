//
//  APINetworking.swift
//
//
//  Created by Admin on 03/11/21.
//
import  UIKit
import Photos
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

enum AppNetworking {
    
    static var timeOutInterval = TimeInterval(59)
//    static let dispose = DisposeBag()
    
    @discardableResult
    private static func executeRequest(_ request: NSMutableURLRequest, _ result: @escaping APIResponse) -> URLSessionDataTask {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = timeOutInterval
        request.timeoutInterval = timeOutInterval

        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _ , error) in
            if error == nil {
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                            printDebug("Response: ======= \n")
                            printDebug(jsonDataDict)
                            DispatchQueue.main.async(execute: { () -> Void in
                                result(.success(JSON(jsonDataDict)))
                            })
                        }
                        
                    } else {
                        let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"TDStringConstants.noDataFound.value"])
                        result(.failure(error))
                    }
                } catch let err as NSError {
                    let responseString = String(data: data!, encoding: .utf8)
                    printDebug("responseString = \(responseString ?? "")")
                    DispatchQueue.main.async(execute: { () -> Void in
                        result(.failure(err))
                    })
                }
            } else {
                if let err = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        // MARK: - Handle No Internet
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                            AppNetworking.showNoInternetConnectionWindow(request,result)
                        } else {
                            result(.failure(err as NSError))
                        }
                    })
                } else {
                    let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "TDStringConstants.somethingUnexpectedHappened.value"])
                    result(.failure(error))
                }
            }
        })
        
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    fileprivate static func checkRefereshTokenAndExecute(_ request: NSMutableURLRequest, _ loader: Bool, response: @escaping APIResponse) -> URLSessionDataTask {
        return executeRequest(request) { (result) in
            if loader { hideLoader() }
            switch result {
            case .success(let json):
                let message = json["message"].stringValue
                var apiCode: TDApiCode = .success
                
                if let code = TDApiCode(rawValue: json["flag"].intValue) {
                    apiCode = code
                } else if let code = TDApiCode(rawValue: json["meta"]["status"].intValue) {
                    apiCode = code
                } else if let code = TDApiCode(rawValue: json["cod"].intValue) {
                    apiCode = code
                }
                
                switch apiCode {
                case .invalidSeession , .blockUser, .unauthorized:
                    SKToast.show(withMessage: "Session has been expired! Please login again.")
                    VDRouter.loadPreloginScreen()
                case .appUpdate :
                    AppNetworking.showAppUpdateVC()
                case .success:
                    response(.success(json))
                case .badRequest, .undetermined:
                    response(.failure(NSError(localizedDescription: message)))
                default:
                    response(.success(json))
                }
                
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    @discardableResult
    private static func REQUEST(withUrl url: URL?,method: String,postData: Data?,header: [String:String],loader: Bool, response: @escaping APIResponse) -> URLSessionDataTask? {
        
        guard let url = url else {
            let error = NSError(localizedDescription: "Url or parameters not valid")
            response(.failure(error))
            return nil
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = method
//        let languageKey = NSLocale(localeIdentifier: TDUserDefaults.value(forKey: .appLanguage).arrayValue.first?.stringValue ?? TDLanguage.english.key).languageCode
//        let languageCode = TDLanguage(rawValue: languageKey)?.apiCode ?? TDLanguage.english.apiCode
        var updatedHeaders = header
        updatedHeaders["appVersion"] = Bundle.main.releaseVersionNumber ?? "1.0"
        updatedHeaders["deviceName"] = "iPhone12"
        updatedHeaders["deviceType"] = "1"
        updatedHeaders["deviceToken"] = VDUserDefaults.value(forKey: .deviceToken).stringValue
        updatedHeaders["loginType"] = "1"
        if let clientId = ClientModel.currentClientData.client_id {
            updatedHeaders["clientId"] = clientId
        }

        if let locale = ClientModel.currentClientData.locale {
            updatedHeaders["locale"] = locale
        }

        if let operatorToken = ClientModel.currentClientData.operatorToken {
            updatedHeaders["operatorToken"] = operatorToken
        }

        if let accessToken = UserModel.currentUser.access_token {
            updatedHeaders["accessToken"] = accessToken
        }

        printDebug("============ \n Headers are =======> \n\n \(updatedHeaders) \n =================")
        printDebug("============ \n Url is =======> \n\n \(url.absoluteString) \n =================")
        request.allHTTPHeaderFields = updatedHeaders
        request.httpBody = postData
        if loader { AppNetworking.showLoader() }
        
        return checkRefereshTokenAndExecute(request, loader, response: response)
    }
    
    @discardableResult
    static func GET(endPoint: String,
                    parameters: [String: Any] = [:],
                    headers: HTTPHeaders = [:],
                    loader: Bool = true,
                    response: @escaping APIResponse) -> URLSessionDataTask? {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        if JSON(rawValue: parameters) ?? [:] == [:]{
            guard let urlString = (endPoint  + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return nil
                
            }
            let uri = URL(string: urlString)
            
            return REQUEST(withUrl: uri,
                           method: "GET",
                           postData: nil,
                           header: headers,
                           loader: loader,
                           response: response)
        }else{
            guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return nil
               
            }
            let uri = URL(string: urlString)
            
            return REQUEST(withUrl: uri,
                           method: "GET",
                           postData: nil,
                           header: headers,
                           loader: loader,
                           response: response)
        }
        
        
      
        
    }
    
    static func POST(endPoint: String,
                     parameters: [String: Any] = [:],
                     headers: HTTPHeaders = [:],
                     loader: Bool = true,
                     response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        
        REQUEST(withUrl: uri,
                method: "POST",
                postData: postData,
                header: headers,
                loader: loader,
                response: response)
        
    }
    
    static func PATCH(endPoint: String,
                      parameters: [String: Any] = [:],
                      headers: HTTPHeaders = [:],
                      loader: Bool = true,
                      response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "PATCH",
                postData: nil,
                header: headers,
                loader: loader,
                response: response)
        
    }
    
    static func POSTWithRawJSON(endPoint: String,
                                parameters: [String: Any] = [:],
                                headers: HTTPHeaders = [:],
                                loader: Bool = true,
                                response: @escaping APIResponse) -> URLSessionDataTask? {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var updatedHeader = headers
        
        updatedHeader["Content-Type"] = "application/json"
        return REQUEST(withUrl: uri,
                       method: "POST",
                       postData: postData,
                       header: updatedHeader,
                       loader: loader,
                       response: response)
        
    }
    
    static func POSTWithImage(endPoint: String,
                              parameters: [String: Any] = [:],
                              image: [String: UIImage] = [:],
                              headers: HTTPHeaders = [:],
                              loader: Bool = true,
                              response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let boundary = generateBoundary()
        let postData = createDataBody(withParameters: parameters, media: image, boundary: boundary)
        var updatedHeader = headers
        
        updatedHeader["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        REQUEST(withUrl: uri,
                method: "POST",
                postData: postData,
                header: updatedHeader,
                loader: loader,
                response: response)
        
    }
    static func PUT(endPoint: String,
                    parameters: [String: Any] = [:],
                    headers: HTTPHeaders = [:],
                    loader: Bool = true,
                    response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        
        REQUEST(withUrl: uri,
                method: "PUT",
                postData: postData,
                header: headers,
                loader: loader,
                response: response)
        
    }
    
    static func PUTWithRawJSON(endPoint: String,
                               parameters: [String: Any] = [:],
                               headers: HTTPHeaders = [:],
                               loader: Bool = true,
                               response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var updatedHeader = headers
        
        updatedHeader["Content-Type"] = "application/json"
        
        REQUEST(withUrl: uri,
                method: "PUT",
                postData: postData,
                header: updatedHeader,
                loader: loader,
                response: response)
        
    }
    
    static func PATCHWithRawJSON(endPoint: String,
                                 parameters: [String: Any] = [:],
                                 headers: HTTPHeaders = [:],
                                 loader: Bool = true,
                                 response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var updatedHeader = headers
        
        updatedHeader["Content-Type"] = "application/json"
        
        REQUEST(withUrl: uri,
                method: "PATCH",
                postData: postData,
                header: updatedHeader,
                loader: loader,
                response: response)
        
    }
    
    static func DELETE(endPoint: String,
                       parameters: [String: Any] = [:],
                       headers: HTTPHeaders = [:],
                       loader: Bool = true,
                       response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "DELETE",
                postData: nil,
                header: headers,
                loader: loader,
                response: response)
        
    }
    
    static func deleteWithRawJson(endPoint: String,
                                  parameters: [String: Any] = [:],
                                  headers: HTTPHeaders = [:],
                                  loader: Bool = true,
                                  response: @escaping APIResponse) {
        
        printDebug("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        let uri = URL(string: endPoint)
        
        let postData = encodeParamaters(params: parameters).data(using: String.Encoding.utf8)
        
        var header = headers
        header["content-type"] = "application/x-www-form-urlencoded"
        
        REQUEST(withUrl: uri,
                method: "DELETE",
                postData: postData,
                header: header,
                loader: loader,
                response: response)
    }
    
    static private func encodeParamaters(params: [String: Any]) -> String {
        
        var result = ""
        
        for key in params.keys {
            
            result.append(key+"=\(params[key] ?? "")&")
            
        }
        
        if !result.isEmpty {
            result.remove(at: result.index(before: result.endIndex))
        }
        
        return result
    }
    
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func createDataBody(withParameters params: [String:Any]?, media: [String:UIImage]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media.keys {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo)\"; filename=\" image.jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                
                let data = media[photo]!.jpegData(compressionQuality: 0.7)
                body.append(data!)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

extension AppNetworking {
    
    static func showLoader() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotateMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = VDColors.buttonSelectedOrange.color
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    static func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension AppNetworking {
    
    static var basicAuth: String {
        let username = ""
        let password = ""
        let authString = String(format: "%@:%@", username, password)
        let authData = authString.data(using: String.Encoding.utf8)!
        return "Basic " + authData.base64EncodedString()
    }
}

// MARK: - Handle No Internet Connection
extension AppNetworking {

    static func showNoInternetConnectionWindow( _ request: NSMutableURLRequest, _ result: @escaping APIResponse) {
        AppNetworking.hideLoader()
        SKToast.show(withMessage: "No internet connection.")
//        if sharedAppDelegate.window?.currentViewController?.isKind(of: TDBottomPopUpVC.self) == true { return }
//        let presentedViewController = TDBottomPopUpVC.instantiate(fromAppStoryboard: TDStoryboard.preLogin)
//        presentedViewController.strTitle = TDStringConstants.noInternetConnection.value
//        presentedViewController.strSubTitle = TDStringConstants.connectTowifiCellularNetwork.value
//        presentedViewController.btnFirstTitle = strButtonTitle
//        presentedViewController.imgPopUp = TDImageAsset.icNoInternet.asset
//        presentedViewController.shouldActiveSecondButtonDismiss = false
//        presentedViewController.isUsedForInternetOfflinePopup = true
//        presentedViewController.shouldClickFirstButtonSubject.subscribe(onNext: { (_) in
//            if request.url != nil {
//                executeRequest(request,result)
//            } else {
//                result(.success(JSON()))
//            }
//
//        }).disposed(by: dispose)
//
//        presentedViewController.shouldClickSecondButtonSubject.subscribe(onNext: {(_) in
//            AppNetworking.callToUser()
//        }).disposed(by: dispose)
//        sharedAppDelegate.window?.currentViewController?.present(presentedViewController, animated: true, completion: nil)
    }

    // MARK: - Call User
    private static func callToUser() {
//        let riderDetails = ""//TDSaveRideModel.currentRide.rideRequestAcceptModel.riderDetails
//        let phoneNumber = riderDetails.countryCode + riderDetails.phoneNumber
//        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
}

// MARK: - Show App update VC
extension AppNetworking {
    
    static func showAppUpdateVC() {
//        guard let currentVC  = sharedAppDelegate.window?.currentViewController else { return }
//        let controller =  TDAppUpdateVC.instantiate(fromAppStoryboard: .utility)
//        let navController = UINavigationController(rootViewController: controller)
//        navController.view.backgroundColor = UIColor.clear
//        navController.modalPresentationStyle = .overFullScreen
//        currentVC.present(navController, animated: false, completion: nil)
    }
}
