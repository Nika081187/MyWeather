//
//  ViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.07.2021.
//

import UIKit
import SnapKit
import CoreLocation
import Alamofire
import SwiftyJSON

let api_key = "d1706e13c1806a01f0e2155432f125a8"
let WEATHER_URL_ONE_DAY = "http://api.openweathermap.org/data/2.5/weather"
let WEATHER_URL_HOURLY = "https://api.openweathermap.org/data/2.5/onecall?exclude=current,minutely,daily,alerts&"
let WEATHER_URL_MOUNTH = "https://api.openweathermap.org/data/2.5/onecall?exclude=current,minutely,hourly,alerts&"

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    private var weatherDataModelOneDay = WeatherDatamodelOneDay()
    private var weatherDatamodelMonthly = WeatherDatamodelMonthly()
    private var weatherDataModelHourly = WeatherDatamodelHourly()
    
    private let temperatureTable = UITableView(frame: .infinite, style: .plain)
    
    private var isInit = false
    
    private var reuseId: String {
        String(describing: DayWithTemperature.self)
    }
    
    init(weather: WeatherDatamodelOneDay) {
        super.init(nibName: nil, bundle: nil)
        self.weatherDataModelOneDay = weather
        defaults.set(weather.lat, forKey: "lat")
        defaults.set(weather.lon, forKey: "lon")
        updateUIWithWeatherData()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if let lat = defaults.value(forKey: "lat"), let lon = defaults.value(forKey: "lon") {

            let params: [String : String] = ["lat": "\(lat)", "lon": "\(lon)", "appid": api_key]
            getWeatherDataOnOneDay(url: WEATHER_URL_ONE_DAY, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    defaults.set(weatherDataModel.lat, forKey: "lat")
                    defaults.set(weatherDataModel.lon, forKey: "lon")
                    self.weatherDataModelOneDay = weatherDataModel
                    self.updateUIWithWeatherData()
                }
            }
            getWeatherDataMonthly(url: WEATHER_URL_MOUNTH, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    self.weatherDatamodelMonthly = weatherDataModel
                    self.updateTableData()
                }
            }
            
            getWeatherDataHourly(url: WEATHER_URL_HOURLY, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    self.weatherDataModelHourly = weatherDataModel
                    self.updateCollectionViewData()
                }
            }
        }
        
        hourlyCollectionView.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        hourlyCollectionView.collectionViewLayout = layout
        hourlyCollectionView.allowsMultipleSelection = false
        
        temperatureTable.toAutoLayout()
        temperatureTable.showsVerticalScrollIndicator = false
        temperatureTable.dataSource = self
        temperatureTable.delegate = self
        temperatureTable.register(DayWithTemperature.self, forCellReuseIdentifier: reuseId)

        view.backgroundColor = .white
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let value = defaults.value(forKey: "temperature") {
            return defaults.set(value as? Bool, forKey: "temperature")
        } else {
            defaults.set(true, forKey: "temperature") // true = C, false = F
        }
        
        if let value = defaults.value(forKey: "windSpeed") {
            return defaults.set(value as? Bool, forKey: "windSpeed")
        } else {
            defaults.set(true, forKey: "windSpeed") // true = Mi, false = Km
        }
        
        if let value = defaults.value(forKey: "timeFormat") {
            return defaults.set(value as? Bool, forKey: "timeFormat")
        } else {
            defaults.set(false, forKey: "timeFormat") // true = 12, false = 24
        }
        
        if let value = defaults.value(forKey: "notifications") {
            return defaults.set(value as? Bool, forKey: "notifications")
        } else {
            defaults.set(true, forKey: "notifications") // true = ON, false = OFF
        }

        if Core.shared.isNewUser() {
            print("Показываем онбординг новому пользователю")
            let vc = OnboardViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let _ = defaults.value(forKey: "lat"), let _ = defaults.value(forKey: "lon") {
            return
        }
        
        if status != .notDetermined || !weatherDataModelOneDay.city.isEmpty {
            updateUIWithWeatherData()
        } else if Core.shared.isNewUser() {
            print("Показываем онбординг новому пользователю")
            let vc = OnboardViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        print("Статус location manager: \(status.rawValue)")
    }

    //MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModelOneDay.city
        temperatureLabel.text = "\(weatherDataModelOneDay.temperature)°"
        let locDescr = Localization.localizedString(key: weatherDataModelOneDay.temperatureDescription)
        temperatureDescription.text = locDescr.capitalizingFirstLetter()
        
        let sunsetDate = NSDate(timeIntervalSince1970: weatherDataModelOneDay.sunset)
        let sunriseDate = NSDate(timeIntervalSince1970: weatherDataModelOneDay.sunrise)
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ru_RU")
        timeFormatter.dateFormat = "HH:mm"
        
        sunsetLabel.text = "\(timeFormatter.string(from: sunsetDate as Date))"
        sunriseLabel.text = "\(timeFormatter.string(from: sunriseDate as Date))"
        humidityLabel.text = "\(weatherDataModelOneDay.humidity)"
        windSpeedLabel.text = "\(weatherDataModelOneDay.windSpeed) м/с"
        cloudsLabel.text = "\(weatherDataModelOneDay.clouds)"
        let date = NSDate(timeIntervalSince1970: weatherDataModelOneDay.date)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter.dateFormat = "HH:mm, EE dd MMMM"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        dateLabel.text = dateString
        feelsLikeTemperatureLabel.text = "\(weatherDataModelOneDay.feelsLike)° / \(weatherDataModelOneDay.temperature)°"
    }
    
    func updateTableData() {
        //
        
        temperatureTable.reloadData()
    }
    
    func updateCollectionViewData() {
        //
        
        hourlyCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUIWithWeatherData()
    }
    
    //MARK: - Location Manager Delegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat": latitude, "lon": longitude, "appid": api_key]
            getWeatherDataOnOneDay(url: WEATHER_URL_ONE_DAY, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    defaults.set(weatherDataModel.lat, forKey: "lat")
                    defaults.set(weatherDataModel.lon, forKey: "lon")
                    self.weatherDataModelOneDay = weatherDataModel
                    self.updateUIWithWeatherData()
                }
            }
            getWeatherDataMonthly(url: WEATHER_URL_MOUNTH, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    self.weatherDatamodelMonthly = weatherDataModel
                    self.updateTableData()
                }
            }
            
            getWeatherDataHourly(url: WEATHER_URL_HOURLY, parameters: params) {  weather in
                if let weatherDataModel = weather {
                    self.weatherDataModelHourly = weatherDataModel
                    self.updateCollectionViewData()
                }
            }
        }
    }
    
    func configure() {
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.addSubview(uiView)
        scrollView.addSubview(cityLabel)

        scrollView.addSubview(locationButton)
        scrollView.addSubview(settingsButton)

        scrollView.addSubview(feelsLikeTemperatureLabel)
        scrollView.addSubview(temperatureLabel)
        scrollView.addSubview(temperatureDescription)
        
        scrollView.addSubview(sunsetLabel)
        scrollView.addSubview(sunriseLabel)
        scrollView.addSubview(sunsetImage)
        scrollView.addSubview(sunriseImage)
        scrollView.addSubview(cloudsLabel)
        scrollView.addSubview(cloudsImage)
        scrollView.addSubview(humidityImage)
        scrollView.addSubview(humidityLabel)
        scrollView.addSubview(windSpeedImage)
        scrollView.addSubview(windSpeedLabel)
        scrollView.addSubview(dateLabel)
        
        scrollView.addSubview(moreFor24Hours)
        scrollView.addSubview(hourlyCollectionView)
        scrollView.addSubview(dailyLabel)
        scrollView.addSubview(temperatureTable)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        cityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(40)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(22)
        }
        
        locationButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(cityLabel)
            make.height.equalTo(30)
            make.width.equalTo(20)
            make.trailing.equalTo(scrollView).offset(-15)
        }
        
        settingsButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(cityLabel)
            make.height.equalTo(50)
            make.leading.equalTo(scrollView).offset(15)
        }
        
        uiView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(112)
            make.height.equalTo(212)
            make.width.equalTo(view.frame.width - 30)
            make.trailing.equalTo(scrollView).offset(-15)
            make.leading.equalTo(scrollView).offset(15)
        }
        
        feelsLikeTemperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView).offset(33)
            make.centerX.equalTo(uiView)
            make.height.equalTo(20)
            make.width.equalTo(85)
        }
        
        temperatureLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView).offset(58)
            make.centerX.equalTo(uiView)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        temperatureDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            make.centerX.equalTo(uiView)
            make.height.equalTo(20)
        }
        
        sunriseLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView.snp.top).offset(167)
            make.height.equalTo(20)
            make.leading.equalTo(uiView).offset(17)
        }
        
        sunsetLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView.snp.top).offset(167)
            make.height.equalTo(20)
            make.trailing.equalTo(scrollView).offset(-30)
        }
        
        sunriseImage.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(sunriseLabel.snp.top).offset(-5)
            make.height.equalTo(15)
            make.width.equalTo(20)
            make.center.equalTo(sunriseLabel)
        }
        
        sunsetImage.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(sunsetLabel.snp.top).offset(-5)
            make.height.equalTo(15)
            make.width.equalTo(20)
            make.center.equalTo(sunsetLabel)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.centerX.equalTo(uiView)
        }
        
        windSpeedImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.trailing.equalTo(windSpeedLabel.snp.leading).offset(-6)
        }
        
        cloudsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.trailing.equalTo(windSpeedImage.snp.leading).offset(-6)
        }
        
        cloudsImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.trailing.equalTo(cloudsLabel.snp.leading).offset(-6)
        }
        
        humidityImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(windSpeedLabel.snp.trailing).offset(10)
        }
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.leading.equalTo(humidityImage.snp.trailing).offset(6)
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.centerX.equalTo(uiView)
        }
        
        moreFor24Hours.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(uiView.snp.bottom).offset(20)
            make.trailing.equalTo(temperatureTable)
            make.height.equalTo(20)
        }
        
        hourlyCollectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(moreFor24Hours.snp.bottom).offset(10)
            make.height.equalTo(85)
            make.leading.equalTo(scrollView).offset(16)
            make.trailing.equalTo(scrollView).offset(-16)
        }
        
        dailyLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(30)
            make.leading.equalTo(scrollView).offset(16)
            make.height.equalTo(22)
        }
        
        temperatureTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dailyLabel.snp.bottom).offset(10)
            make.leading.equalTo(scrollView).offset(16)
            make.trailing.equalTo(scrollView).offset(-16)
            make.bottom.equalTo(view)
        }
    }
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.setImage(#imageLiteral(resourceName: "location"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(locationButtonClicked), for:.touchUpInside)
        return button
    }()
    
    @objc func locationButtonClicked() {
        print("Нажали кнопку locationButton")
        let vc = OnboardViewController(needResetLocations: true)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.tintColor = .black
        button.setImage(UIImage(systemName: "text.alignright"), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonClicked), for:.touchUpInside)
        return button
    }()
    
    @objc func settingsButtonClicked() {
        print("Нажали кнопку settingsButton")
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private lazy var temperatureDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private let sunsetImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = UIImage(systemName: "sunset")
        theImageView.tintColor = .yellow
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    private let sunriseImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = UIImage(systemName: "sunrise")
        theImageView.tintColor = .yellow
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.toAutoLayout()
        return scroll
    }()
    
    private lazy var uiView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 212, height: 300))
        view.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        view.toAutoLayout()
        return view
    }()

    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var cloudsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()

    private let cloudsImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = #imageLiteral(resourceName: "clouds2")
        theImageView.tintColor = .yellow
        theImageView.contentMode = .scaleAspectFit
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()

    lazy var humidityImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = #imageLiteral(resourceName: "humidity2")
        theImageView.tintColor = .yellow
        theImageView.contentMode = .scaleAspectFit
        theImageView.toAutoLayout()
        return theImageView
    }()

    lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var windSpeedImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = #imageLiteral(resourceName: "windSpeed2")
        theImageView.tintColor = .yellow
        theImageView.contentMode = .scaleAspectFit
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 0.965, green: 0.867, blue: 0.004, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HourlyCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.toAutoLayout()
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
       pageControl.pageIndicatorTintColor = .gray
       pageControl.currentPageIndicatorTintColor = .white
       return pageControl
    }()
    
    lazy var dailyLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 22)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        
        label.attributedText = NSMutableAttributedString(string: "Ежедневный прогноз", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    private lazy var moreFor24Hours: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 174, height: 20)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        label.font = UIFont(name: "Rubik-Regular", size: 16)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        
        label.textAlignment = .right
        label.attributedText = NSMutableAttributedString(string: "Подробнее на 24 часа", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        return label
    }()
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        print("Кликнули погоду на 24 часа")
        let vc = WeatherOn24HoursController(weatherModel: weatherDataModelHourly, city: weatherDataModelOneDay.city)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDataModelHourly.hourly.count / 3
       }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell

        let image = UIImage(systemName: "sun.max")!
        let sectionNumber = indexPath.row * 3
        if weatherDataModelHourly.hourly.count == 0 {
            return cell
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "ru_RU")
        let hour = "\(timeFormatter.string(from: Date(timeIntervalSince1970: weatherDataModelHourly.hourly[sectionNumber].date)))"

        cell.configure(image: image, temperature: weatherDataModelHourly.hourly[sectionNumber].temperature, hour: "\(hour)")
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HourlyCollectionViewCell {
            cell.selected()
        }
    }
}


extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DayWithTemperature = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! DayWithTemperature
        cell.toAutoLayout()
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        if weatherDatamodelMonthly.days.count == 0 {
            return cell
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd/MM"
        timeFormatter.locale = Locale(identifier: "ru_RU")
        let data = "\(timeFormatter.string(from: Date(timeIntervalSince1970: weatherDatamodelMonthly.days[indexPath.section].date)))"
        let locDescr = Localization.localizedString(key: weatherDatamodelMonthly.days[indexPath.section].weatherDescr)
        cell.configure(description: "\(locDescr.capitalizingFirstLetter())",
                       data: data,
                       humidity: weatherDatamodelMonthly.days[indexPath.section].humidity,
                       temperature: "\(weatherDatamodelMonthly.days[indexPath.section].temperatureDay)° >")
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherDatamodelMonthly.days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрали день: \(indexPath.item + 1)")
        let vc = DayWeatherViewController(weatherModel: weatherDatamodelMonthly, day: indexPath.item + 1, city: weatherDataModelOneDay.city, sunrise: weatherDataModelOneDay.sunrise)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
