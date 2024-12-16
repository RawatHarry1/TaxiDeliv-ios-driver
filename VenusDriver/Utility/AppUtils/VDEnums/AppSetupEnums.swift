//
//  AppSetupEnums.swift
//
//
//  Created by Amit on 09/05/22.
//

import Foundation

enum AppEnvironment: String {
    
    case dev
    case qa
    case stage
    case production
    
    /// "hostURL": used to invite people to view content on TaxiCoin
    var hostURL: String {
        switch self {
        case .dev: return ""
        case .qa: return ""
        case .stage: return ""
        case .production: return ""
        }
    }
    
    /// ''baseURL": the primary url on which apis function
    var baseURL: String {
        switch self {
        case .dev: return "https://dev-rides.venustaxi.in"
        case .qa: return "http://43.204.229.91:8080"
        case .stage: return "https://chuki-rides.venustaxi.in"
        case .production: return "https://super-app-rides.venustaxi.in"
        }
    }
    
    /// ''socketUrl": the primary url on which socket function
    var socketUrl: String {
        switch self {
        case .dev: return "https://dev-rides-api.venustaxi.in"
        case .qa: return "https://43.204.229.91:4012"
        case .stage: return "https://chuki-rides-api.venustaxi.in"
        case .production: return "https://super-app-rides-api.venustaxi.in"
        }
    }
    
    var googlPlacesKey:String {
        switch self {
        case .dev: return ClientModel.currentClientData.google_map_keys!
        case .qa: return ClientModel.currentClientData.google_map_keys!
        case .stage: return ClientModel.currentClientData.google_map_keys!
        case .production: return ClientModel.currentClientData.google_map_keys!
        }
    }

    /// ''baseURL": the primary url on which apis function
    var googlePlaceURL: String {
        switch self {
        case .dev: return "https://maps.googleapis.com/"
        case .qa: return "https://maps.googleapis.com/"
        case .stage : return "https://maps.googleapis.com/"
        case .production: return "https://maps.googleapis.com/"
        }
    }

    var googleClientId :String {
        switch self {
        case .dev: return ""
        case .qa: return ""
        case .stage: return ""
        case .production: return ""
        }
    }
    
    var staticContentURL: String {
        return ""
    }
    
    var key: String {
        return self.rawValue
    }
    
    var imageBaseURL: String {
        switch self {
        case .dev: return ""
        case .qa: return ""
        case .stage: return ""
        case .production: return ""
        }
    }
}
