
import UIKit

class WeatherView: UIView {
    
    private let weatherInfoShortLabel = UILabel(text: "Солнечно", font:.robotoMedium18(), textColor: .specialGray)
    
    private let weatherInfoFulltLabel: UILabel = {
        let fullInfo = UILabel()
        fullInfo.text = "Хорошая погода, чтобы позаниматься на улице."
        fullInfo.textColor = .specialGray
        fullInfo.font = .robotoMedium14()
        fullInfo.numberOfLines = 2
        fullInfo.adjustsFontSizeToFitWidth = true
        fullInfo.translatesAutoresizingMaskIntoConstraints = false
        return fullInfo
    }()
    
    private let weatherImage: UIImageView = {
        let imageSun = UIImageView()
        imageSun.image = UIImage(named: "SunImage")
        imageSun.translatesAutoresizingMaskIntoConstraints = false
        return imageSun
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.9813271165, green: 0.9813271165, blue: 0.9813271165, alpha: 1)
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherImage)
        addSubview(weatherInfoShortLabel)
        addSubview(weatherInfoFulltLabel)
        addShadowOnView()
    }
    
    public func updateImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        weatherImage.image = image
    }
    
    public func updateLabels(model: WeatherModel) {
        weatherInfoShortLabel.text = model.weather[0].myDescription + " \(model.main.temperatureCelsius)°C"
        
        switch model.weather[0].weatherDescription {
        case "clear sky":
            weatherInfoFulltLabel.text = "Хорошая погода, чтобы позаниматься на улице."
        default:
            weatherInfoFulltLabel.text = "No data"
        }
    }
}
//MARK: - setConstraints

    extension WeatherView {
        
    private func setConstraints() {
        NSLayoutConstraint.activate([
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImage.widthAnchor.constraint(equalToConstant: 60),
            weatherImage.heightAnchor.constraint(equalToConstant: 60),
            
            weatherInfoShortLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherInfoShortLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherInfoShortLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -10),
            weatherInfoShortLabel.heightAnchor.constraint(equalToConstant: 20),
            
            weatherInfoFulltLabel.topAnchor.constraint(equalTo: weatherInfoShortLabel.bottomAnchor, constant: 0),
            weatherInfoFulltLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherInfoFulltLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -10),
            weatherInfoFulltLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
}
