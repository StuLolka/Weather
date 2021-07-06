//
//  ExtensionStartViewController.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 04.07.2021.
//

import Foundation
import CoreLocation

extension StartViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return }
        loadDataCurrentCity(location: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong in locationManager: \(error.localizedDescription)")
    }
}
