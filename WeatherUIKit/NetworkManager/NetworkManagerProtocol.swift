//
//  NetworkManagerProtocol.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 02.07.2021.
//

import CoreLocation

protocol NetworkManagerProtocol {
    
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherModel) -> ())
}
