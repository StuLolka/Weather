
final class ScreenBuilder {
    
    static var shared: ScreenBuilder {
        return ScreenBuilder()
    }
    
    func initialWeatherViewController() -> WeatherViewController {
        let presenter = WeatherPresenter()
        let view = WeatherViewController(presenter: presenter)
        view.presenter.view = view
        return view
    }
}
