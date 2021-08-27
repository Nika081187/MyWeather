//
//  SettingsViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 26.08.2021.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private lazy var uiView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 330)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.toAutoLayout()
        return view
    }()
    
    private lazy var settingsLabel: UILabel = {
        var label = UILabel()

        label.frame = CGRect(x: 0, y: 0, width: 112, height: 15)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.153, green: 0.153, blue: 0.133, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.7

        label.attributedText = NSMutableAttributedString(string: "Настройки", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    private lazy var temperatureSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.isOn = defaults.bool(forKey: "temperature")
        switch1.toAutoLayout()
        return switch1
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Температура (C / F)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.toAutoLayout()
        return label
    }()
    
    private lazy var windSpeedSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.isOn = defaults.bool(forKey: "windSpeed")
        switch1.toAutoLayout()
        return switch1
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Скорость ветра (Mi / Km)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.toAutoLayout()
        return label
    }()
    
    private lazy var timeFormatSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.isOn = defaults.bool(forKey: "timeFormat")
        switch1.toAutoLayout()
        return switch1
    }()
    
    private lazy var timeFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "Формат времени (12 / 24)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.toAutoLayout()
        return label
    }()
    
    private lazy var notificationSwitch: UISwitch = {
        let switch1 = UISwitch()
        switch1.isOn = defaults.bool(forKey: "notifications")
        switch1.toAutoLayout()
        return switch1
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомления (OFF / ON)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.toAutoLayout()
        return label
    }()
    
    private lazy var setSettingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Установить", for: .normal)
        button.backgroundColor = UIColor(red: 0.95, green: 0.43, blue: 0.07, alpha: 1.00)
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(setSettingsButtonClicked), for:.touchUpInside)

        button.toAutoLayout()
        return button
    }()
    
    @objc func setSettingsButtonClicked() {
        print("Нажали кнопку setSettingsButton")
        
        defaults.set(temperatureSwitch.isOn, forKey: "temperature")
        defaults.set(windSpeedSwitch.isOn, forKey: "windSpeed")
        defaults.set(timeFormatSwitch.isOn, forKey: "timeFormat")
        defaults.set(notificationSwitch.isOn, forKey: "notifications")
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor

        configure()
    }
    
    func configure() {
        view.addSubview(uiView)
        view.addSubview(settingsLabel)
        view.addSubview(temperatureSwitch)
        view.addSubview(temperatureLabel)
        view.addSubview(windSpeedSwitch)
        view.addSubview(windSpeedLabel)
        view.addSubview(timeFormatSwitch)
        view.addSubview(timeFormatLabel)
        view.addSubview(notificationLabel)
        view.addSubview(notificationSwitch)
        view.addSubview(setSettingsButton)
        
        uiView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(view)
            make.height.equalTo(330)
            make.width.equalTo(320)
            make.trailing.equalTo(view).offset(-28)
            make.leading.equalTo(view).offset(27)
        }
        
        settingsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView).offset(27)
            make.height.equalTo(20)
            make.leading.equalTo(uiView).offset(20)
        }
        
        temperatureSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView).offset(62)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.trailing.equalTo(uiView).offset(-30)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView).offset(62)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(uiView).offset(20)
        }
        
        windSpeedSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.trailing.equalTo(uiView).offset(-30)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(uiView).offset(20)
        }
        
        timeFormatSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.trailing.equalTo(uiView).offset(-30)
        }
        
        timeFormatLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(uiView).offset(20)
        }
        
        notificationSwitch.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(timeFormatSwitch.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.trailing.equalTo(uiView).offset(-30)
        }
        
        notificationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(timeFormatSwitch.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(uiView).offset(20)
        }
        
        setSettingsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(notificationLabel.snp.bottom).offset(42)
            make.height.equalTo(40)
            make.bottom.equalTo(uiView).offset(-16)
            make.width.equalTo(250)
            make.centerX.equalTo(uiView)
        }
    }
}
