//
//  ViewController.swift
//  WeatherUIKit
//
//  Created by Сэнди Белка on 02.07.2021.
//

import UIKit
import CoreLocation

// http://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=bdfba249e4cd206073100bbe3978c661
class StartViewController: UIViewController {
    
    public let locationManager = CLLocationManager()
    private let networkManager = WeatherNetworkManager()
    
    private let currentLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "City name"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    private let currentDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current date"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let currentTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "500000º"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        return label
    }()
    
    private let feelsLike: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feels like: 1500000"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let maxTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H: tempº"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let minTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "L: tempº"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        image.image = UIImage(systemName: "questionmark")
        return image
    }()
    
    private let weatherDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Here will be description of weather"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        addRightBarButton()
        addConstraints()
        locationManager.delegate = self
//        loadDataSpecificCity(city: "Moscow")
    }
    
    private func addRightBarButton() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeCity))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func addConstraints() {
        view.addSubview(currentLocation)
        view.addSubview(currentDate)
        view.addSubview(currentTemperature)
        view.addSubview(feelsLike)
        view.addSubview(maxTemperature)
        view.addSubview(minTemperature)
        view.addSubview(weatherImage)
        view.addSubview(weatherDescription)
        
        NSLayoutConstraint.activate([
            currentLocation.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            currentLocation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            currentDate.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 30),
            currentDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentTemperature.topAnchor.constraint(equalTo: currentDate.bottomAnchor, constant: 30),
            currentTemperature.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            maxTemperature.topAnchor.constraint(equalTo: currentTemperature.bottomAnchor, constant: 30),
            maxTemperature.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            maxTemperature.widthAnchor.constraint(equalToConstant: 80),
            
            minTemperature.topAnchor.constraint(equalTo: currentTemperature.bottomAnchor, constant: 30),
            minTemperature.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            minTemperature.widthAnchor.constraint(equalTo: maxTemperature.widthAnchor),
            
            feelsLike.topAnchor.constraint(equalTo: minTemperature.bottomAnchor, constant: 15),
            feelsLike.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: feelsLike.bottomAnchor, constant: 30),
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 80),
            weatherImage.heightAnchor.constraint(equalToConstant: 80),
            
            weatherDescription.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 30),
            weatherDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            weatherDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
    }
    
    
    private func loadDataSpecificCity(city: String) {
        networkManager.fetchCurrentWeather(city: city) { weather in
            self.addDataToLabel(weather: weather)
        }
    }
    
    public func loadDataCurrentCity(location: CLLocationCoordinate2D) {
        
        networkManager.fetchCurrentLocationWeather(lat: location.latitude, lon: location.longitude) { weather in
            self.addDataToLabel(weather: weather)
        }
    }
    
    private func addDataToLabel(weather: WeatherModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        DispatchQueue.main.async {
            self.currentTemperature.text = (String(weather.main.temp) + "°C")
            self.feelsLike.text = ("Feels like: " + String(weather.main.feels_like) + "°C")
            self.currentDate.text = formatter.string(from: Date())
            self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
            self.weatherDescription.text = weather.weather[0].description
            self.minTemperature.text = ("L: " + String(weather.main.temp_min) + "°C" )
            self.maxTemperature.text = ("H: " + String(weather.main.temp_max) + "°C" )
            self.weatherImage.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
            UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
        }
    }
    
    public func getAlert() {

        let alertController = UIAlertController(title: "Error", message: "I can't find this city:(", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func changeCity() {
        
        let alertController = UIAlertController(title: "Enter city", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Go", style: .default, handler: {_ in
            guard let textField = alertController.textFields else {return }
            guard let city = textField[0].text else {return }
            self.loadDataSpecificCity(city: city)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

