//
//  HourlyCollectionViewCell.swift
//  MyWeather
//
//  Created by v.milchakova on 25.08.2021.
//

import UIKit
import SnapKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 42, height: 83)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 22
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(red: 0.671, green: 0.737, blue: 0.918, alpha: 1).cgColor
        return contentView
    }()
    
    private lazy var weatherImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.toAutoLayout()
        photoImage.contentMode = .scaleAspectFit
        return photoImage
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.toAutoLayout()
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.toAutoLayout()
        return label
    }()
    
    public func configure(image: UIImage, temperature: Int, hour: Date){
        weatherImage.image = image
        temperatureLabel.text = "\(temperature)"
        hourLabel.text = "\(hour)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(contentView)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(hourLabel)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.height.equalTo(83)
            make.width.equalTo(42)
        }
        
        hourLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(containerView.snp.bottom).offset(2)
            make.centerX.equalTo(containerView)
            make.height.equalTo(32)
            make.width.equalTo(18)
        }
        
        weatherImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hourLabel.snp.bottom).offset(2)
            make.centerX.equalTo(containerView)
            make.height.equalTo(32)
            make.width.equalTo(18)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(weatherImage.snp.bottom).offset(2)
            make.centerX.equalTo(containerView)
            make.height.equalTo(32)
            make.width.equalTo(18)
        }
    }
}

