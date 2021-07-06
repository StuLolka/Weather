//
//  WeatherNetworkManager.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 02.07.2021.
//

import UIKit
import CoreLocation

final class WeatherNetworkManager: NetworkManagerProtocol {
    
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ()) {

        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)&units=metric"

        guard let url = URL(string: API_URL) else {
            StartViewController().getAlertWithError()
            print("Something went wrong: URL error")
            return
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }

            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                DispatchQueue.main.async {
                    StartViewController().getAlertWithError()
                }
                print("Something went wrong: \(error.localizedDescription)")
            }

        }.resume()
        
    }

    
    func fetchCurrentLocationWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherModel) -> ()) {
        guard let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(NetworkProperties.API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return }
        guard let url = URL(string: urlString) else {return }
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil, let data = data else {return }

            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                print("Something went wrong: \(error.localizedDescription)")
            }
        }.resume()
        
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
}

struct Sys: Codable {
    let country: String?
}

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
}

struct NetworkProperties {
    static let API_KEY = "bdfba249e4cd206073100bbe3978c661"
}
