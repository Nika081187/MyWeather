//
//  DayWeatherViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 27.08.2021.
//

import UIKit

class DayWeatherViewController: UIViewController {
    
    var dayNumber: Int
    var weatherDataModel: WeatherDatamodelMonthly
    var city: String
    var sunrise: Double
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.toAutoLayout()
        return scroll
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1), for: .normal)
        button.tintColor = .black
        button.setTitle("← Дневная погода", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(backButtonClicked), for:.touchUpInside)
        return button
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var dayUiView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 212, height: 300))
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        view.layer.cornerRadius = 5
        view.toAutoLayout()
        return view
    }()
    
    lazy var dayTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    private lazy var nightUiView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 212, height: 300))
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        view.layer.cornerRadius = 5
        view.toAutoLayout()
        return view
    }()
    
    lazy var nightTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    @objc func backButtonClicked() {
        print("Нажали кнопку backButton")
        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    init(weatherModel: WeatherDatamodelMonthly, day: Int, city: String, sunrise: Double) {
        self.dayNumber = day
        self.weatherDataModel = weatherModel
        self.city = city
        self.sunrise = sunrise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Этот инит не работает")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.addSubview(backButton)
        scrollView.addSubview(cityLabel)
        scrollView.addSubview(dayUiView)
        scrollView.addSubview(dayTimeLabel)
        scrollView.addSubview(nightUiView)
        scrollView.addSubview(nightTimeLabel)
        
        let moonView = MoonView(weatherDatamodel: weatherDataModel.days[dayNumber], sunrise: sunrise)
        
        scrollView.addSubview(moonView)
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.leading.equalTo(scrollView).offset(15)
        }
        
        cityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.leading.equalTo(scrollView).offset(15)
            make.trailing.equalTo(scrollView).offset(-15)
        }
        
        addDayView()
        addNightView()
        
        moonView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nightUiView.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
        }
        
        dayUiView.accessibilityIdentifier = "day"
        nightUiView.accessibilityIdentifier = "night"
        makeUiView(dayUiView)
        makeUiView(nightUiView)
    }
    
    func addDayView() {
        cityLabel.text = city
        dayTimeLabel.text = "День"
        
        dayUiView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(110)
            make.height.equalTo(300)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView).offset(-30)
        }
        
        dayTimeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dayUiView).offset(21)
            make.height.equalTo(22)
            make.width.equalTo(60)
            make.leading.equalTo(dayUiView).offset(15)
        }
    }
    
    func addNightView() {
        nightTimeLabel.text = "Ночь"
        
        nightUiView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dayUiView.snp.bottom).offset(12)
            make.height.equalTo(300)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView).offset(-30)
        }
        
        nightTimeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nightUiView).offset(21)
            make.height.equalTo(22)
            make.width.equalTo(60)
            make.leading.equalTo(nightUiView).offset(15)
        }
    }
    
    func makeUiView(_ viewToTheDay: UIView) {
        // Температура
        let temperatureLabel = UILabel()
        temperatureLabel.toAutoLayout()
        temperatureLabel.font = UIFont.systemFont(ofSize: 30)
        if viewToTheDay.accessibilityIdentifier!.contains("day") {
            temperatureLabel.text = "\(weatherDataModel.days[dayNumber].temperatureDay)°"
        } else {
            temperatureLabel.text = "\(weatherDataModel.days[dayNumber].temperatureNight)°"
        }

        scrollView.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewToTheDay).offset(15)
            make.height.equalTo(32)
            make.width.equalTo(50)
            make.centerX.equalTo(scrollView)
        }
        
        // Описание
        let temperatureDescriptionLabel = UILabel()
        temperatureDescriptionLabel.toAutoLayout()
        temperatureDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        temperatureDescriptionLabel.textAlignment = .center
        let locDescr = Localization.localizedString(key: weatherDataModel.days[dayNumber].weatherDescr)
        temperatureDescriptionLabel.text = "\(locDescr.capitalizingFirstLetter())"
        scrollView.addSubview(temperatureDescriptionLabel)
        
        temperatureDescriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(11)
            make.height.equalTo(22)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.centerX.equalTo(scrollView)
        }
        
        // По ощущениям
        let feelsLikeLabel = UILabel()
        feelsLikeLabel.toAutoLayout()
        feelsLikeLabel.font = UIFont.systemFont(ofSize: 14)
        feelsLikeLabel.text = "По ощущениям"
        scrollView.addSubview(feelsLikeLabel)
        
        feelsLikeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewToTheDay).offset(112)
            make.height.equalTo(19)
            make.width.equalTo(104)
            make.leading.equalTo(viewToTheDay).offset(54)
        }
        
        let lineView1 = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0.5))
        lineView1.toAutoLayout()
        lineView1.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        scrollView.addSubview(lineView1)
        
        lineView1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.width.equalTo(dayUiView)
            make.centerX.equalTo(scrollView)
        }
        
        // Ветер
        let windSpeedLabel = UILabel()
        windSpeedLabel.toAutoLayout()
        windSpeedLabel.font = UIFont.systemFont(ofSize: 14)
        windSpeedLabel.text = "Ветер"
        scrollView.addSubview(windSpeedLabel)
        
        windSpeedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(27)
            make.height.equalTo(19)
            make.width.equalTo(104)
            make.leading.equalTo(viewToTheDay).offset(54)
        }
        
        let lineView2 = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0.5))
        lineView2.toAutoLayout()
        lineView2.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        scrollView.addSubview(lineView2)
        
        lineView2.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.width.equalTo(dayUiView)
            make.centerX.equalTo(scrollView)
        }
        
        // Дождь
        let humidityLabel = UILabel()
        humidityLabel.toAutoLayout()
        humidityLabel.font = UIFont.systemFont(ofSize: 14)
        humidityLabel.text = "Дождь"
        scrollView.addSubview(humidityLabel)
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(27)
            make.height.equalTo(19)
            make.width.equalTo(104)
            make.leading.equalTo(viewToTheDay).offset(54)
        }
        
        let lineView3 = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0.5))
        lineView3.toAutoLayout()
        lineView3.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        scrollView.addSubview(lineView3)
        
        lineView3.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.width.equalTo(dayUiView)
            make.centerX.equalTo(scrollView)
        }
        
        // Облачность
        let cloudsLabel = UILabel()
        cloudsLabel.toAutoLayout()
        cloudsLabel.font = UIFont.systemFont(ofSize: 14)
        cloudsLabel.text = "Облачность"
        scrollView.addSubview(cloudsLabel)
        
        cloudsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityLabel.snp.bottom).offset(27)
            make.height.equalTo(19)
            make.width.equalTo(104)
            make.leading.equalTo(viewToTheDay).offset(54)
        }
        
        let lineView4 = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0.5))
        lineView4.toAutoLayout()
        lineView4.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        scrollView.addSubview(lineView4)
        
        lineView4.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cloudsLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.width.equalTo(dayUiView)
            make.centerX.equalTo(scrollView)
        }
        
        // По ощущениям Value
        let feelsLikeValueLabel = UILabel()
        feelsLikeValueLabel.toAutoLayout()
        feelsLikeValueLabel.font = UIFont.systemFont(ofSize: 14)
        feelsLikeLabel.textAlignment = .right
        if viewToTheDay.accessibilityIdentifier!.contains("day") {
            feelsLikeValueLabel.text = "\(weatherDataModel.days[dayNumber].feelsLikeDay)°"
        } else {
            feelsLikeValueLabel.text = "\(weatherDataModel.days[dayNumber].feelsLikeNight)°"
        }
        
        scrollView.addSubview(feelsLikeValueLabel)
        
        feelsLikeValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewToTheDay).offset(112)
            make.height.equalTo(16)
            make.width.equalTo(35)
            make.trailing.equalTo(viewToTheDay).offset(-20)
        }
        
        // Ветер Value
        let windSpeedValueLabel = UILabel()
        windSpeedValueLabel.toAutoLayout()
        windSpeedValueLabel.textAlignment = .right
        windSpeedValueLabel.font = UIFont.systemFont(ofSize: 14)
        windSpeedValueLabel.text = "\(weatherDataModel.days[dayNumber].windSpeed) m\\s"
        
        scrollView.addSubview(windSpeedValueLabel)
        
        windSpeedValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feelsLikeValueLabel.snp.bottom).offset(27)
            make.height.equalTo(22)
            make.width.equalTo(70)
            make.trailing.equalTo(viewToTheDay).offset(-20)
        }
        
        // Дождь Value
        let humidityValueLabel = UILabel()
        humidityValueLabel.toAutoLayout()
        humidityValueLabel.font = UIFont.systemFont(ofSize: 14)
        humidityValueLabel.textAlignment = .right
        humidityValueLabel.text = "\(weatherDataModel.days[dayNumber].humidity) %"
        scrollView.addSubview(humidityValueLabel)
        
        humidityValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedValueLabel.snp.bottom).offset(27)
            make.height.equalTo(22)
            make.width.equalTo(35)
            make.trailing.equalTo(viewToTheDay).offset(-20)
        }
        
        // Облачность Value
        let cloudsValueLabel = UILabel()
        cloudsValueLabel.toAutoLayout()
        cloudsValueLabel.font = UIFont.systemFont(ofSize: 14)
        cloudsValueLabel.textAlignment = .right
        cloudsValueLabel.text = "\(weatherDataModel.days[dayNumber].clouds) %"
        scrollView.addSubview(cloudsValueLabel)
        
        cloudsValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(humidityValueLabel.snp.bottom).offset(27)
            make.height.equalTo(22)
            make.width.equalTo(35)
            make.trailing.equalTo(viewToTheDay).offset(-20)
        }
        
        let feelsLikeImageView = UIImageView()
        feelsLikeImageView.image = #imageLiteral(resourceName: "feelsLike")
        feelsLikeImageView.toAutoLayout()
        scrollView.addSubview(feelsLikeImageView)
        
        feelsLikeImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.leading.equalTo(viewToTheDay).offset(15)
            make.centerY.equalTo(feelsLikeValueLabel)
        }
        
        let windSpeedImageView = UIImageView()
        windSpeedImageView.image = #imageLiteral(resourceName: "windSpeed")
        windSpeedImageView.toAutoLayout()
        scrollView.addSubview(windSpeedImageView)
        
        windSpeedImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.leading.equalTo(viewToTheDay).offset(15)
            make.centerY.equalTo(windSpeedValueLabel)
        }
        
        let humidityImageView = UIImageView()
        humidityImageView.image = #imageLiteral(resourceName: "humidity")
        humidityImageView.toAutoLayout()
        scrollView.addSubview(humidityImageView)
        
        humidityImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.leading.equalTo(viewToTheDay).offset(15)
            make.centerY.equalTo(humidityValueLabel)
        }
        
        let cloudsImageView = UIImageView()
        cloudsImageView.image = #imageLiteral(resourceName: "clouds")
        cloudsImageView.toAutoLayout()
        scrollView.addSubview(cloudsImageView)
        
        cloudsImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.leading.equalTo(viewToTheDay).offset(15)
            make.centerY.equalTo(cloudsValueLabel).offset(-3)
        }
    }
}
