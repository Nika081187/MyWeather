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
    
    public func configure(description: String, data: String, humidity: Int, temperature: Int){
        descriptionLabel.text = description
        dataLabel.text = data
        humidityLabel.text = "\(humidity)"
        temperatureLabel.text = "\(temperature)"
    }

    private lazy var descriptionLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.toAutoLayout()
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    
    private lazy var dataLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.toAutoLayout()
        descriptionLabel.textColor = .gray
        descriptionLabel.font = descriptionLabel.font.withSize(14)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private lazy var humidityLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.toAutoLayout()
        likesLabel.textColor = .black
        likesLabel.font = descriptionLabel.font.withSize(16)
        return likesLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.toAutoLayout()
        viewsLabel.textColor = .black
        viewsLabel.font = descriptionLabel.font.withSize(16)
        return viewsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(humidityLabel)
        
        dataLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(6)
            make.leading.equalTo(contentView).offset(10)
            make.height.equalTo(19)
            make.width.equalTo(53)
        }
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dataLabel.snp.bottom).offset(6)
            make.height.equalTo(23)
            make.width.equalTo(16)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(19)
            make.leading.equalTo(humidityLabel).offset(13)
            make.trailing.equalTo(contentView).offset(-72)
            make.height.equalTo(20)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(19)
            make.trailing.equalTo(contentView).offset(-26)
            make.height.equalTo(20)
            make.width.equalTo(43)
        }
    }
}

