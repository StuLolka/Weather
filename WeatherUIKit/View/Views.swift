import UIKit

final class Views {
    
    public let currentLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        return label
    }()
    
    public let currentTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        return label
    }()
    
    public let feelsLike: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feels like: --"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    public let maxTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H: --"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    public let minTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "L: --"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    public let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        image.image = UIImage(systemName: "questionmark")
        return image
    }()
    
    public let weatherDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "--"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    init(viewHeight: CGFloat) {
        currentLocation.font = UIFont.systemFont(ofSize: viewHeight / 13, weight: .heavy)
        currentTemperature.font = UIFont.systemFont(ofSize: viewHeight / 9, weight: .bold)
        maxTemperature.font = UIFont.systemFont(ofSize: viewHeight / 31, weight: .medium)
        minTemperature.font = UIFont.systemFont(ofSize: viewHeight / 31, weight: .medium)
        feelsLike.font = UIFont.systemFont(ofSize: viewHeight / 41, weight: .light)
        weatherDescription.font = UIFont.systemFont(ofSize: viewHeight / 36, weight: .light)
    }
}
