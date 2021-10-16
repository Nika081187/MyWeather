//
//  DayWithTemperature.swift
//  MyWeather
//
//  Created by v.milchakova on 25.08.2021.
//

import UIKit
import SnapKit

class DayWithTemperature: UITableViewCell {
    let baseOffset: CGFloat =  16
    
    public func configure(description: String, data: String, humidity: Int, temperature: String){
        descriptionLabel.text = description
        dataLabel.text = data
        humidityLabel.text = "\(humidity)%"
        temperatureLabel.text = "\(temperature)"
    }

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dataLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.toAutoLayout()
        dataLabel.textColor = .gray
        dataLabel.font = UIFont.systemFont(ofSize: 16)
        dataLabel.numberOfLines = 0
        return dataLabel
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.toAutoLayout()
        viewsLabel.textColor = .black
        viewsLabel.font = UIFont.systemFont(ofSize: 18)
        return viewsLabel
    }()
    
    private let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "humidity")
        imageView.contentMode = .scaleAspectFit
        imageView.toAutoLayout()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.layer.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1).cgColor
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(humidityImage)
        contentView.addSubview(humidityLabel)
        
        dataLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(6)
            make.leading.equalTo(contentView).offset(10)
            make.height.equalTo(19)
            make.width.equalTo(53)
        }
        
        humidityImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dataLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dataLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView).offset(30)
            make.height.equalTo(16)
            make.width.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(19)
            make.leading.equalTo(contentView).offset(66)
            make.height.equalTo(20)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(19)
            make.trailing.equalTo(contentView).offset(-26)
            make.height.equalTo(20)
        }
    }
}

