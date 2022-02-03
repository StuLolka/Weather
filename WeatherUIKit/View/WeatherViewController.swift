
import UIKit
import CoreLocation

protocol WeatherPresenterProtocol {
    var view: WeatherViewProtocol? { get set }
    
    func startRequestLocation()
    func loadDataSpecificCity(city: String)
    func getUserLocation()
}

final class WeatherViewController: UIViewController, WeatherViewProtocol {
    
    var presenter: WeatherPresenterProtocol
    
    public let locationManager = CLLocationManager()
    private let networkManager = WeatherNetworkManager()
    private lazy var views = Views(viewHeight: view.bounds.height)
    
    private lazy var currentLocation = views.currentLocation
    
    private lazy var currentTemperature = views.currentTemperature
    
    private lazy var feelsLike = views.feelsLike
    
    private lazy var maxTemperature = views.maxTemperature
    
    private lazy var minTemperature = views.minTemperature
    
    private lazy var weatherImage = views.weatherImage
    
    private lazy var weatherDescription = views.weatherDescription
    
    init(presenter: WeatherPresenterProtocol) {
         self.presenter = presenter
         super.init(nibName: nil, bundle: nil)
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) is not supported")
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonsToNavigationBar()
        addConstraints()
        view.backgroundColor = .systemBackground
        
        presenter.startRequestLocation()
    }
    
    func addDataToLabel(weather: WeatherModel) {

        DispatchQueue.main.async {
            self.currentTemperature.text = (String(Int(weather.main.temp)) + "°C")
            self.feelsLike.text = ("Feels like: " + String(Int(weather.main.feels_like)) + "°C")
            self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
            self.weatherDescription.text = weather.weather[0].description
            self.minTemperature.text = ("L: " + String(Int(weather.main.temp_min)) + "°C" )
            self.maxTemperature.text = ("H: " + String(Int(weather.main.temp_max)) + "°C" )
            self.weatherImage.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
            UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
        }
    }
    
    // MARK: - alerts
    func getAlertWithError() {
        let alertController = UIAlertController(title: "Error", message: "I can't find this city:(", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - navigation bar
    private func addButtonsToNavigationBar() {
        let locationButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .done, target: self, action: #selector(getUserLocation))
        locationButton.tintColor = UIColor(named: "Black&White")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeCity))
        rightBarButton.tintColor = UIColor(named: "Black&White")
        navigationItem.rightBarButtonItems = [rightBarButton, locationButton]
    }
    
    //MARK: - constraints
    private func addConstraints() {
        view.addSubview(currentLocation)
        view.addSubview(currentTemperature)
        view.addSubview(feelsLike)
        view.addSubview(maxTemperature)
        view.addSubview(minTemperature)
        view.addSubview(weatherImage)
        view.addSubview(weatherDescription)
        
        NSLayoutConstraint.activate([
            
            currentLocation.bottomAnchor.constraint(equalTo: currentTemperature.topAnchor, constant: -30),
            currentLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            currentLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            
            currentTemperature.bottomAnchor.constraint(equalTo: maxTemperature.topAnchor, constant: -30),
            currentTemperature.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            maxTemperature.topAnchor.constraint(equalTo: currentTemperature.bottomAnchor, constant: 30),
            maxTemperature.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            maxTemperature.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width / -3.9),
            maxTemperature.widthAnchor.constraint(equalToConstant: view.bounds.width / 5),
            
            minTemperature.topAnchor.constraint(equalTo: currentTemperature.bottomAnchor, constant: 30),
            minTemperature.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            minTemperature.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: -(view.bounds.width / -3.9) - view.bounds.width / 5),
            minTemperature.widthAnchor.constraint(equalTo: maxTemperature.widthAnchor),
            
            feelsLike.topAnchor.constraint(equalTo: minTemperature.bottomAnchor, constant: 15),
            feelsLike.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: feelsLike.bottomAnchor, constant: 30),
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 80),
            weatherImage.heightAnchor.constraint(equalToConstant: 80),
            
            weatherDescription.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 30),
            weatherDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            weatherDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
        
    }

    @objc func changeCity() {
        
        let alertController = UIAlertController(title: "Enter city", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Go", style: .default, handler: {_ in
            guard let textField = alertController.textFields else {return }
            guard let city = textField[0].text else {return }
            self.presenter.loadDataSpecificCity(city: city)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - @objc func get user location
    @objc func getUserLocation() {
        presenter.getUserLocation()
    }
    
}

