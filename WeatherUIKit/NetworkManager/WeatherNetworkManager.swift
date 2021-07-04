//
//  WeatherNetworkManager.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 02.07.2021.
//

import UIKit

final class WeatherNetworkManager: NetworkManagerProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ()) {

        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)"

        guard let url = URL(string: API_URL) else {
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
                self.showError()
                print("Something went wrong: \(error.localizedDescription)")
            }

        }.resume()
        
    }
    
    func showError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "I can't find this city:(", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            StartViewController().getAlert()
//            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
            print("AALALLLALALAL")
        }
    }

    
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ()) {
//        print(error.localizedDescription)
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
    let pressure: Float
    let humidity: Float
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
    let dt: Int
    let timezone: Int?
    let dt_txt: String?
}

struct NetworkProperties {
    static let API_KEY = "bdfba249e4cd206073100bbe3978c661"
}
