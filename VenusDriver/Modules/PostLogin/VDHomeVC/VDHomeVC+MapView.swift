//
//  VDHomeVC+MapView.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import Foundation
import GoogleMaps

extension VDHomeVC {

    func setUpMap() {
        self.mapView.isMyLocationEnabled = true
        let camera = GMSCameraPosition(latitude: 42.536457, longitude: -70.985786, zoom: 14)
        self.mapView.camera = camera
    }

    func refreshMap(_ location : CLLocation) {
        DispatchQueue.main.async {
            self.mapView.isMyLocationEnabled = true
            if self.cameraUpdateOnce == true{
                self.cameraUpdateOnce = false
                let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
                self.mapView.camera = camera
            }
           
        }
        
        //self.mapView.animate(to: camera)
    }

    
}
