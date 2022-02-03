import CoreLocation

protocol WeatherViewProtocol {
    var presenter: WeatherPresenterProtocol { get }
    
    func getAlertWithError()
    func addDataToLabel(weather: WeatherModel)
}

final class WeatherPresenter: NSObject, WeatherPresenterProtocol {
    
    var view: WeatherViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let networkManager = WeatherNetworkManager()
    
    func startRequestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
    func getUserLocation() {
        guard let location = locationManager.location?.coordinate else {return }
        loadDataCurrentCity(location: location)
    }
    
    //MARK: - load and add data
    func loadDataSpecificCity(city: String) {
        networkManager.fetchCurrentWeather(city: city) { weather in
            guard let weather = weather else {
                DispatchQueue.main.async {
                    self.view?.getAlertWithError()
                }
                return
            }
            self.view?.addDataToLabel(weather: weather)
        }
    }
    
    private func loadDataCurrentCity(location: CLLocationCoordinate2D) {
        
        networkManager.fetchCurrentLocationWeather(lat: location.latitude, lon: location.longitude) { weather in
            self.view?.addDataToLabel(weather: weather)
        }
    }
}

extension WeatherPresenter: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return }
        loadDataCurrentCity(location: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong in locationManager: \(error.localizedDescription)")
    }
}
