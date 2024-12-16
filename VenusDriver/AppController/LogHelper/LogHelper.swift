//
//  LogHelper.swift
//  VenusDriver
//
//  Created by Amit on 19/02/24.
//

import Foundation

class LogHelper {

    static let shared = LogHelper()
    static let enableLog:Bool = false
    // Help file : https://github.com/vigneshuvi/SwiftLoggly

    private init() {
        Loggly.logger.maxFileSize = 10240
        Loggly.logger.maxFileCount = 16
    }

    // MARK: - Debug Log file
    func debugLoggerPrint( _ message: [String:Any], extra1: String = #file, extra2: String = #function, extra3: Int = #line) {
        if LogHelper.enableLog {
            var receiveData = message
            let filename = (extra1 as NSString).lastPathComponent
            receiveData["file"] = filename
            receiveData["Line"] = extra3
            receiveData["function"] = extra2
            logglyInfo(receiveData)
        }
    }

    // MARK: - error Log file
    func errorLoggerPrint( _ message: [String:Any], extra1: String = #file, extra2: String = #function, extra3: Int = #line) {
        if LogHelper.enableLog {
            var receiveData = message
            let filename = (extra1 as NSString).lastPathComponent
            receiveData["file"] = filename
            receiveData["Line"] = extra3
            receiveData["function"] = extra2
            logglyError(receiveData)
        }
    }

    func getDocumentDirectoryPath() {
        printDebug(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }
}
