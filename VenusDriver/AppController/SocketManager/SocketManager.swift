//
//  VCSocketManager.swift
//  VenusCustomer
//
//  Created by Amit on 17/01/24.
//

import Foundation
import SocketIO

enum VCEventListnerKeys: String {
    case didConnect = "connect"
    case locationUpdate = "driver-tracking"
    case send_message = "send_message"
    case list_of_message = "list_of_message"
    case msg_receiver_listener = "msg_receiver_listener"
    //_8978_962
    static func dynamicMsgReceiverListener(id1: String) -> String {
            return "msg_receiver_listener_\(id1)"
        }
//    case didDisConnect = "disconnect"
//    case reconnect = "reconnect"
//    case reconnectAttempt = "reconnectAttempt"
//    case ping = "PING"
//    case pong = "PONG"
//    case locationEvent = "location"
//    case newRideRequest = "new_ride_request"
//    case rides = "rides"
//    case trips = "trips"
//    case rideCancelled =  "ride_cancelled"
//    case chats = "chats"
//    case getNewMessage = "get_message"
//    case rideRequestCancelled = "ride_request_cancelled"
//    case rideEdited = "ride_edited"
//    case markReadMsg = "mark_read_messages"
//    case versionError = "version-err"
}

class VCSocketIOManager: NSObject {

    private var socket: SocketIOClient?
    private var manager: SocketManager?
    static var shared = VCSocketIOManager()

    override init() {
        super.init()
        initializeSocket()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    private func initializeSocket() {
        manager = SocketManager(socketURL: URL(string: sharedAppDelegate.appEnvironment.socketUrl)!, config: [
            .log(true),
            .compress,
            .secure(true),
            .selfSigned(true),
            .reconnects(true),
            .reconnectWait(5),
            .reconnectAttempts(-1),
            .forceNew(true),
            .path("/socket.io/")
        ])
        socket = manager?.defaultSocket
        setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }

        socket?.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected, attempting to reconnect")
            self.socket?.connect()
        }

        socket?.on(clientEvent: .reconnect) { data, ack in
            print("Socket reconnecting")
        }

        socket?.on(clientEvent: .reconnectAttempt) { data, ack in
            print("Socket reconnect attempt")
        }

        socket?.on(clientEvent: .error) { data, ack in
            print("Socket error: \(data)")
        }

        socket?.on("error") { data, ack in
            print("Socket error event: \(data)")
        }
    }

    var socketStatus: SocketIOStatus {
        return socket?.status ?? .notConnected
    }

    fileprivate var socketHandlerArr = [((() -> Void))]()
    typealias ObjBlock = @convention(block) () -> Void

    func connectSocket(handler:(() -> Void)? = nil) {
        if socket?.status == .connected {
            handler?()
            return
        } else {
            if let handlr = handler {
                if !socketHandlerArr.contains(where: { (handle) -> Bool in
                    let obj1 = unsafeBitCast(handle as ObjBlock, to: AnyObject.self)
                    let obj2 = unsafeBitCast(handlr as ObjBlock, to: AnyObject.self)
                    return obj1 === obj2
                }) {
                    socketHandlerArr.append(handlr)
                }
            }

            if socket?.status != .connecting {
                socket?.connect()
            }
        }

        socket?.on(VCEventListnerKeys.didConnect.rawValue) { [weak self] data, ack in
            guard let self = self else { return }
            debugPrint(data,ack)
            debugPrint("===================CONNECTED===================")
            for handler in self.socketHandlerArr {
                handler()
            }
            self.socketHandlerArr = []
        }

        socket?.on(clientEvent: .error) { data, ack in
            debugPrint("TCSocket Error in Connection", data, ack)
            AppNetworking.hideLoader()
        }
    }

    func closeConnection() {
        socket?.disconnect()
    }

    func on(for event: VCEventListnerKeys, callback: @escaping NormalCallback) {
        socket?.on(event.rawValue, callback: callback)
    }
    
    func onn(event: String, callback: @escaping NormalCallback) {
        socket?.on(event, callback: callback)
    }
    
    func off(event: String) {
        socket?.off(event)
    }
    func removeAllHandlers() {
        socket?.removeAllHandlers()
    }
    
    @objc private func applicationDidEnterBackground() {
        socket?.connect()
    }

    @objc private func applicationWillEnterForeground() {
        socket?.connect()
    }

    func emit(with event: VCEventListnerKeys, _ params : JSONDictionary? , loader:Bool = false) {
        if socket?.status != .connected {
            connectSocket(handler: { [weak self] in
                self?.emitWithACK(withTimeoutAfter: 10, event: event, params: params, array: nil , loader:loader)
            })
        } else {
            emitWithACK(withTimeoutAfter: 10, event: event, params: params, array: nil , loader:loader)
        }
    }

    private func emitWithACK(withTimeoutAfter seconds: Double, event: VCEventListnerKeys, params : JSONDictionary?, array:[Any]? , loader:Bool) {
        if loader { AppNetworking.showLoader() }
        LogHelper.shared.debugLoggerPrint(["emit event :":params?.debugDescription ?? ""])
        var ack : OnAckCallback?
        if let tempParams = params {
            ack = socket?.emitWithAck(event.rawValue, tempParams)
        } else if let tempArray = array {
            ack = socket?.emitWithAck(event.rawValue, tempArray)
        } else {
            ack = socket?.emitWithAck(event.rawValue)
        }
        ack?.timingOut(after: seconds, callback: { [weak self] (data) in
            AppNetworking.hideLoader()
            LogHelper.shared.debugLoggerPrint(["event response :":data.first.debugDescription])
            switch event {
            case .locationUpdate:
                self?.handleLocationACK(data: data)
            default: break
            }
        })
    }

    func handleLocationACK(data: [Any]) {
        let json = JSON(data.first as Any)
        if let apiCode =  TDApiCode(rawValue: json["statusCode"].intValue) {
            switch apiCode {
            case .invalidSeession :
                SKToast.show(withMessage: "Your session has been expired.")
                VDRouter.loadPreloginScreen(false)
            default:
                if let data = try? json["data"].rawData() {
                    printDebug(data)
                }
            }
        }
    }
}

extension VCSocketIOManager : URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

class VCSocketServices {
    static let shared = VCSocketServices()
    private init() {}
    
    var pendingTypingTask: DispatchWorkItem?
    
    func listneAllMessage() {
        getAllMessageListner()
    }
    
    func listnMessage(listnr: String) {
        msgReceiverListner(listner: listnr)
    }
    
    private func getAllMessageListner() {
        VCSocketIOManager.shared.on(for: .list_of_message) { (data, ack) in
            debugPrint(data,ack)
            let json = JSON(data.first as Any)
            if let jsonString = data.first as? String {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let threadModel = try JSONDecoder().decode(GetAllMessages.self, from: jsonData)
                        let encodedData = try JSONEncoder().encode(threadModel)
                        NotificationCenter.default.post(name: .getAllMessages, object: nil, userInfo: ["model": encodedData])
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }
        }
    }
    
    private func msgReceiverListner(listner: String) {
        let eventName = VCEventListnerKeys.dynamicMsgReceiverListener(id1: listner)
        VCSocketIOManager.shared.off(event: eventName)
        VCSocketIOManager.shared.onn(event: eventName) { (data, ack) in
            debugPrint(data, ack)
            guard let firstData = data.first else { return }
            let json = JSON(firstData)
            do {
                let jsonData = try json.rawData()
                let threadModel = try JSONDecoder().decode(singleMessageMoal.self, from: jsonData)
                let encodedData = try JSONEncoder().encode(threadModel)
                NotificationCenter.default.post(name: .getSingleMessage, object: nil, userInfo: ["model": encodedData])
            } catch {
                print("Decoding error: \(error)")
            }
        }
    }
}
