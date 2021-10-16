//
//  MoonView.swift
//  MyWeather
//
//  Created by v.milchakova on 03.10.2021.
//

import UIKit

class MoonView: UIView {
    var weatherDatamodel: Day!
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Солнце и Луна"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    private lazy var sunLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.contentMode = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var moonLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.contentMode = .center
        label.toAutoLayout()
        return label
    }()
    
    private let sunImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = #imageLiteral(resourceName: "sun")
        theImageView.contentMode = .scaleAspectFit
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    private let moonImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = #imageLiteral(resourceName: "moon")
        theImageView.contentMode = .scaleAspectFit
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    lazy var sunsetSunLabel: UILabel = {
        let label = UILabel()
        label.text = "Заход"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseSunLabel: UILabel = {
        let label = UILabel()
        label.text = "Восход"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunsetSunValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseSunValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunsetMoonLabel: UILabel = {
        let label = UILabel()
        label.text = "Заход"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseMoonLabel: UILabel = {
        let label = UILabel()
        label.text = "Восход"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunsetMoonValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseMoonValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()

    init(weatherDatamodel: Day, sunrise: Double) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.accessibilityFrame.width, height: 300))
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "ru_RU")
        
        self.weatherDatamodel = weatherDatamodel
        self.sunsetSunValue.text = "\(timeFormatter.string(from: Date(timeIntervalSince1970: weatherDatamodel.sunset)))"
        self.sunriseSunValue.text = "\(timeFormatter.string(from: Date(timeIntervalSince1970: sunrise)))"
        self.sunsetMoonValue.text = "\(timeFormatter.string(from: Date(timeIntervalSince1970: weatherDatamodel.moonset)))"
        self.sunriseMoonValue.text = "\(timeFormatter.string(from: Date(timeIntervalSince1970: weatherDatamodel.moonrise)))"
        
        let timeFormatter2 = DateFormatter()
        timeFormatter2.dateFormat = "HH ч mm мин"
        timeFormatter2.locale = Locale(identifier: "ru_RU")
        let sunTime = weatherDatamodel.sunset - sunrise
        let moonTime = weatherDatamodel.moonset - weatherDatamodel.moonrise
        
        self.sunLabel.text = "\(timeFormatter2.string(from: Date(timeIntervalSince1970: sunTime)))"
        self.moonLabel.text = "\(timeFormatter2.string(from: Date(timeIntervalSince1970: moonTime)))"
        
        self.backgroundColor = .white
        print("My Custom Init")
        
        setupLayout()
    }
    
    func setupLayout() {
        
        let lineView1 = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 0.5))
        lineView1.toAutoLayout()
        lineView1.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 0.5))
        lineView2.toAutoLayout()
        lineView2.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        
        let lineView3 = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 0.5))
        lineView3.toAutoLayout()
        lineView3.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        
        let lineView4 = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 0.5))
        lineView4.toAutoLayout()
        lineView4.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)

        addSubview(mainLabel)
        addSubview(sunLabel)
        addSubview(moonLabel)
        addSubview(sunImage)
        addSubview(lineView1)
        addSubview(moonImage)
        addSubview(lineView2)
        
        addSubview(sunsetSunLabel)
        addSubview(sunsetSunValue)
        addSubview(sunriseSunLabel)
        addSubview(sunriseSunValue)
        
        addSubview(lineView3)
        addSubview(lineView4)

        addSubview(sunsetMoonLabel)
        addSubview(sunsetMoonValue)
        addSubview(sunriseMoonLabel)
        addSubview(sunriseMoonValue)
        
        mainLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(130)
            make.leading.equalTo(self).offset(16)
        }
        
        sunImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(self).offset(34)
        }
        
        sunLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(130)
            make.leading.equalTo(sunImage.snp.trailing).offset(16)
        }
        
        moonImage.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(sunImage)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(sunLabel.snp.trailing).offset(16)
        }

        moonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(sunImage)
            make.height.equalTo(20)
            make.width.equalTo(130)
            make.leading.equalTo(moonImage.snp.trailing).offset(16)
        }
        
        lineView1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunLabel.snp.bottom).offset(12)
            make.height.equalTo(0.5)
            make.leading.equalTo(mainLabel)
            make.trailing.equalTo(sunLabel)
        }
        
        lineView2.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(moonLabel.snp.bottom).offset(12)
            make.height.equalTo(0.5)
            make.leading.equalTo(moonImage)
            make.trailing.equalTo(moonLabel)
        }
        // Восход Солнца
        sunriseSunLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lineView1.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(70)
            make.leading.equalTo(sunImage)
        }
        
        lineView3.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseSunLabel.snp.bottom).offset(12)
            make.height.equalTo(0.5)
            make.leading.equalTo(mainLabel)
            make.trailing.equalTo(sunLabel)
        }
        
        // Заход
        sunsetSunLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseSunLabel.snp.bottom).offset(16)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.leading.equalTo(sunImage)
        }
        // восход время
        sunsetSunValue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunsetSunLabel)
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.trailing.equalTo(sunLabel)
        }
        // заход время
        sunriseSunValue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseSunLabel)
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.trailing.equalTo(sunLabel)
        }

        // Восход Луны
        sunriseMoonLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lineView2.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(70)
            make.leading.equalTo(moonImage)
        }
        
        lineView4.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseMoonLabel.snp.bottom).offset(12)
            make.height.equalTo(0.5)
            make.leading.equalTo(moonImage)
            make.trailing.equalTo(moonLabel)
        }
        
        // Заход
        sunsetMoonLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseMoonLabel.snp.bottom).offset(16)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.leading.equalTo(moonImage)
        }
        // восход время
        sunsetMoonValue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunsetMoonLabel)
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.trailing.equalTo(moonLabel)
        }
        // заход время
        sunriseMoonValue.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sunriseMoonLabel)
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.trailing.equalTo(moonLabel)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
