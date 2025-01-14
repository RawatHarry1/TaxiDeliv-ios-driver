//
//  StepsModel.swift
//  SaloneRide
//
//  Created by TechBuilder on 14/01/25.
//

import Foundation

// MARK: - Step Model
struct Step: Codable {
    let distance: Distance
    let duration: Duration
    let endLocation: Location
    let htmlInstructions: String
    let polyline: Polyline
    let startLocation: Location
    let travelMode: TravelMode
    let maneuver: String?
    
    enum CodingKeys: String, CodingKey {
        case distance, duration, polyline, maneuver
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case startLocation = "start_location"
        case travelMode = "travel_mode"
    }
}

// MARK: - Distance Model
struct Distance: Codable {
    let text: String
    let value: Int
}

// MARK: - Duration Model
struct Duration: Codable {
    let text: String
    let value: Int
}

// MARK: - Location Model
struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

// MARK: - Polyline Model
struct Polyline: Codable {
    let points: String
}

// MARK: - TravelMode Enum
enum TravelMode: String, Codable {
    case walking = "WALKING"
    case driving = "DRIVING"
    case bicycling = "BICYCLING"
    case transit = "TRANSIT"
}

