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

class WeatherViewController: UITabBarController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let WEATHER_URL_HOURLY = "http://api.openweathermap.org/data/2.5/forecast/hourly"
    let WEATHER_URL_MOUNTH = "http://api.openweathermap.org/data/2.5/forecast/climate"
    let api_key = "d1706e13c1806a01f0e2155432f125a8"
    private var center: CGFloat = 0.0
    
    let locationManager = CLLocationManager()
    
    let weatherDataModel = WeatherDatamodel()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.toAutoLayout()
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.toAutoLayout()
        return label
    }()
    
    lazy var temperatureDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.toAutoLayout()
        return label
    }()
    
    let sunsetImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = UIImage(systemName: "sunset")
        theImageView.tintColor = .yellow
        theImageView.toAutoLayout()
        return theImageView
    }()
    
    let sunriseImage: UIImageView = {
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
    
    private lazy var scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.toAutoLayout()
        return view
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
        cv.backgroundColor = .white
        cv.toAutoLayout()
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        center = view.frame.width / 2

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()

        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(uiView)
        scrollViewContainer.addSubview(cityLabel)
        scrollViewContainer.addSubview(feelsLikeTemperatureLabel)
        scrollViewContainer.addSubview(temperatureLabel)
        scrollViewContainer.addSubview(temperatureDescription)
        
        scrollViewContainer.addSubview(sunsetLabel)
        scrollViewContainer.addSubview(sunriseLabel)
        scrollViewContainer.addSubview(sunsetImage)
        scrollViewContainer.addSubview(sunriseImage)
        scrollViewContainer.addSubview(humidityLabel)
        scrollViewContainer.addSubview(windSpeedLabel)
        scrollViewContainer.addSubview(dateLabel)
        
        configureScroll()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.isNewUser() {
            print("Показываем онбординг новому пользователю")
            let vc = OnboardViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    private func configureScroll() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        scrollViewContainer.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
        }
    }
    
    func setupLayout() {
        
        cityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(40)
            make.centerX.equalTo(center)
            make.height.equalTo(22)
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
            make.width.equalTo(60)
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
    
    func setupTabs(locations: [Location]) {
        var list = [LocationViewController]()
        for l in locations {
            list.append(LocationViewController(location: l))
        }
        list.append(LocationViewController(location: Location()))
        viewControllers = list
    }

    //MARK: - Networking

    func getWeatherData(url: String, parameters: [String: String]) {
        
        AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
            
            switch response.result {
    
            case .success(let value):
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(value)
                self.updateWeatherData(json: weatherJSON)
                print("weatherJSON: " + weatherJSON.debugDescription)

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
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    
    func userEnterNewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : api_key]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HourlyCollectionViewCell()

//        let image = PhotoStorage().photos[indexPath.item]
//        cell.configure(image: image)
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width  - 4 * baseOffset) / 3
//        return CGSize(width: width, height: width)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return baseOffset
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: baseOffset, left: baseOffset, bottom: baseOffset, right: baseOffset)
//    }
}
