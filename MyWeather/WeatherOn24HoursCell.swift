//
//  WeatherOn24HoursCell.swift
//  MyWeather
//
//  Created by v.milchakova on 11.09.2021.
//

import UIKit
import SnapKit

class WeatherOn24HoursCell: UITableViewCell {
    
    public func configure(date: String, temperature: Int, hour: String, feelsLike: Int, windSpeed: String, humidity: String, clouds: String){
        dateLabel.text = date
        temperatureLabel.text = "\(temperature)°"
        hourLabel.text = hour
        feelsLikeValueLabel.text = "\(feelsLike)°"
        windSpeedValueLabel.text = windSpeed
        humidityValueLabel.text = humidity
        cloudsValueLabel.text = clouds
    }
    
    lazy var containerView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return contentView
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.toAutoLayout()
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    // По ощущениям Image
    private lazy var feelsLikeImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "humidity")
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // По ощущениям Label
    lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "По ощущениям"
        return label
    }()
    
    // По ощущениям Value
    lazy var feelsLikeValueLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = .gray
        return label
    }()
    
    // Ветер Image
    private lazy var windSpeedImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "windSpeed")
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // Ветер Label
    lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Ветер"
        return label
    }()
    
    // Ветер Value
    lazy var windSpeedValueLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = .gray
        return label
    }()
    
    // Атмосферные осадки
    private lazy var humidityImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "humidity")
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // Атмосферные осадки Label
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Атмосферные осадки"
        return label
    }()
    
    // Атмосферные осадки Value
    lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = .gray
        return label
    }()
    
    // Облачность
    private lazy var cloudsImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "clouds")
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // Атмосферные осадки Label
    lazy var cloudsLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Облачность"
        return label
    }()
    
    // Атмосферные осадки Value
    lazy var cloudsValueLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(contentView)
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(hourLabel)
        contentView.addSubview(temperatureLabel)
        // По ощущениям
        contentView.addSubview(feelsLikeImageView)
        contentView.addSubview(feelsLikeLabel)
        contentView.addSubview(feelsLikeValueLabel)
        // Ветер
        contentView.addSubview(windSpeedImageView)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(windSpeedValueLabel)
        // Атмосферные осадки
        contentView.addSubview(humidityImageView)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(humidityValueLabel)
        // Облачность
        contentView.addSubview(cloudsImageView)
        contentView.addSubview(cloudsLabel)
        contentView.addSubview(cloudsValueLabel)
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(containerView).offset(20)
            make.leading.equalTo(containerView).offset(16)
            make.height.equalTo(22)
            make.width.equalTo(79)
        }
        
        hourLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView).offset(16)
            make.height.equalTo(19)
            make.width.equalTo(50)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hourLabel.snp.bottom).offset(10)
            make.leading.equalTo(hourLabel)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        // По ощущениям
        feelsLikeImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(hourLabel).offset(40)
            make.centerY.equalTo(hourLabel)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        feelsLikeLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(feelsLikeImageView.snp.trailing).offset(5)
            make.top.equalTo(feelsLikeImageView)
            make.height.equalTo(19)
            make.width.equalTo(200)
        }
        
        feelsLikeValueLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(feelsLikeLabel)
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.trailing.equalTo(containerView).offset(-15)
        }
        
        // Ветер
        windSpeedImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feelsLikeImageView.snp.bottom).offset(8)
            make.leading.equalTo(feelsLikeImageView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedImageView)
            make.leading.equalTo(windSpeedImageView.snp.trailing).offset(5)
            make.height.equalTo(19)
            make.width.equalTo(200)
        }
        
        windSpeedValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel)
            make.height.equalTo(20)
            make.width.equalTo(80)
            make.trailing.equalTo(feelsLikeValueLabel)
        }
        
        // Атмосферные осадки
        humidityImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedImageView.snp.bottom).offset(8)
            make.leading.equalTo(windSpeedImageView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityImageView)
            make.leading.equalTo(humidityImageView.snp.trailing).offset(5)
            make.height.equalTo(19)
            make.width.equalTo(200)
        }
        
        humidityValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityLabel)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.trailing.equalTo(feelsLikeValueLabel)
        }
        
        // Облачность
        cloudsImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityImageView.snp.bottom).offset(8)
            make.leading.equalTo(humidityImageView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        cloudsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cloudsImageView)
            make.leading.equalTo(cloudsImageView.snp.trailing).offset(5)
            make.height.equalTo(19)
            make.width.equalTo(200)
        }
        
        cloudsValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cloudsImageView)
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.trailing.equalTo(feelsLikeValueLabel)
        }
    }
}
