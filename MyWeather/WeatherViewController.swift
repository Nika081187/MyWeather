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

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    private let WEATHER_URL_ONE_DAY = "http://api.openweathermap.org/data/2.5/weather"
    private let WEATHER_URL_HOURLY = "http://api.openweathermap.org/data/2.5/forecast/hourly"
    private let WEATHER_URL_MOUNTH = "http://api.openweathermap.org/data/2.5/forecast/climate"
    private let api_key = "d1706e13c1806a01f0e2155432f125a8"
    
    private let locationManager = CLLocationManager()
    
    private let weatherDataModel = WeatherDatamodel()
    
    private let temperatureTable = UITableView(frame: .infinite, style: .plain)
    
    private var reuseId: String {
        String(describing: DayWithTemperature.self)
    }
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.toAutoLayout()
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.setImage(UIImage(systemName: "location.viewfinder"), for: .normal)
        button.addTarget(self, action: #selector(locationButtonClicked), for:.touchUpInside)
        return button
    }()
    
    @objc func locationButtonClicked() {
        print("Нажали кнопку locationButton")
        let vc = OnboardViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
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
        label.toAutoLayout()
        return label
    }()
    
    lazy var sunriseLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.toAutoLayout()
        return label
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.toAutoLayout()
        return label
    }()

    lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.toAutoLayout()
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 0.965, green: 0.867, blue: 0.004, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.toAutoLayout()
        return label
    }()
    
    lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
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
        label.font = UIFont(name: "Rubik-Medium", size: 18)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        
        label.attributedText = NSMutableAttributedString(string: "Ежедневный прогноз", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    lazy var daysCountLabel: UILabel = {
        var label = UILabel()

        label.frame = CGRect(x: 0, y: 0, width: 83, height: 20)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        label.font = UIFont(name: "Rubik-Regular", size: 16)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05

        label.textAlignment = .right
        label.attributedText = NSMutableAttributedString(string: "25 дней", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        hourlyCollectionView.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        hourlyCollectionView.collectionViewLayout = layout
        hourlyCollectionView.allowsMultipleSelection = false
        
        temperatureTable.toAutoLayout()
        temperatureTable.dataSource = self
        temperatureTable.delegate = self
        temperatureTable.register(DayWithTemperature.self, forCellReuseIdentifier: reuseId)

        view.backgroundColor = .white
        
        view.addSubview(scrollView)
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
        scrollView.addSubview(humidityLabel)
        scrollView.addSubview(windSpeedLabel)
        scrollView.addSubview(dateLabel)
        
        scrollView.addSubview(moreFor24Hours)
        scrollView.addSubview(hourlyCollectionView)
        scrollView.addSubview(dailyLabel)
        scrollView.addSubview(daysCountLabel)
        scrollView.addSubview(temperatureTable)
        
        setupLayout()
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
            make.top.equalTo(cityLabel)
            make.height.equalTo(40)
            make.trailing.equalTo(scrollView).offset(-15)
        }
        
        settingsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cityLabel)
            make.height.equalTo(40)
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
            make.width.equalTo(65)
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
        
        humidityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(temperatureDescription.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.leading.equalTo(windSpeedLabel.snp.trailing).offset(10)
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
        
        daysCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dailyLabel)
            make.height.equalTo(20)
            make.trailing.equalTo(temperatureTable)
        }
        
        temperatureTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dailyLabel.snp.bottom).offset(10)
            make.leading.equalTo(scrollView).offset(16)
            make.trailing.equalTo(scrollView).offset(-16)
            make.bottom.equalTo(view)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("do stuff")
                }
            }
        }
        print("locationManager status: \(status.rawValue)")
    }

    //MARK: - Networking

    func getWeatherDataOnOneDay(url: String, parameters: [String: String]) {
        AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(value)
                self.updateWeatherData(json: weatherJSON)
                print("weatherJSON One Day: " + weatherJSON.debugDescription)

            case .failure(let error):
                print("Error \(error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func getWeatherDataHourly(url: String, parameters: [String: String]) {
        AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(value)
                self.updateWeatherDataHourly(json: weatherJSON)
                print("weatherJSON Hourly: " + weatherJSON.debugDescription)

            case .failure(let error):
                print("Error \(error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func getWeatherDataOnMonth(url: String, parameters: [String: String]) {
        AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(value)
                self.updateWeatherDataOnMonth(json: weatherJSON)
                print("weatherJSON On Month: " + weatherJSON.debugDescription)

            case .failure(let error):
                print("Error \(error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing

    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
            
        weatherDataModel.temperatureDescription = json["weather"][0]["description"].stringValue
            
        weatherDataModel.sunset = json["sys"]["sunset"].doubleValue
            
        weatherDataModel.sunrise = json["sys"]["sunrise"].doubleValue
            
        weatherDataModel.clouds = json["clouds"]["all"].intValue
            
        weatherDataModel.humidity = json["main"]["humidity"].intValue
            
        weatherDataModel.windSpeed = json["wind"]["speed"].floatValue
            
        weatherDataModel.date = json["dt"].doubleValue
            
        if let feelsLikeResult = json["main"]["feels_like"].double {
            weatherDataModel.feelsLike = Int(feelsLikeResult - 273.15)
        }
        
        updateUIWithWeatherData()
        
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateWeatherDataHourly(json: JSON) {
        
    }
    
    func updateWeatherDataOnMonth(json: JSON) {
        
    }

    //MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        temperatureDescription.text = weatherDataModel.temperatureDescription.capitalizingFirstLetter()
        
        let sunsetDate = NSDate(timeIntervalSince1970: weatherDataModel.sunset)
        let sunriseDate = NSDate(timeIntervalSince1970: weatherDataModel.sunrise)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        
        sunsetLabel.text = "\(timeFormatter.string(from: sunsetDate as Date))"
        sunriseLabel.text = "\(timeFormatter.string(from: sunriseDate as Date))"
        humidityLabel.text = "\(weatherDataModel.humidity)"
        windSpeedLabel.text = "\(weatherDataModel.windSpeed)"
        let date = NSDate(timeIntervalSince1970: weatherDataModel.date)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm, MMM dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        dateLabel.text = dateString
        feelsLikeTemperatureLabel.text = "\(weatherDataModel.feelsLike)° / \(weatherDataModel.temperature)°"
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
            
            getWeatherDataOnOneDay(url: WEATHER_URL_ONE_DAY, parameters: params)
//            getWeatherDataHourly(url: WEATHER_URL_HOURLY, parameters: params)
//            getWeatherDataOnMonth(url: WEATHER_URL_MOUNTH, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    
    func userEnterNewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : api_key]
        
        getWeatherDataOnOneDay(url: WEATHER_URL_ONE_DAY, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findCityWeather" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
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
          return 24
       }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell

        let image = UIImage(systemName: "sun.max")!
        cell.configure(image: image, temperature: 20, hour: "\(indexPath.row):00")
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
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
        cell.configure(description: "Солнечно", data: "\(indexPath.section + 1)/12", humidity: 56, temperature: "23°-25°")
        cell.toAutoLayout()
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 25
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
        let vc = DayWeatherViewController(weatherModel: weatherDataModel, day: indexPath.item + 1)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
