//
//  NetworkManagerProtocol.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 02.07.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
//    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}
