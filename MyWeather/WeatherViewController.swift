//
//  ViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.07.2021.
//

import UIKit
//import RealmSwift
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UITabBarController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let api_key = "d1706e13c1806a01f0e2155432f125a8"

    let locationManager = CLLocationManager()
    
    let weatherDataModel = WeatherDatamodel()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "temperatureLabel"
        label.font = UIFont.systemFont(ofSize: 12)
        label.toAutoLayout()
        return label
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "cityLabel"
        label.font = UIFont.systemFont(ofSize: 12)
        label.toAutoLayout()
        return label
    }()
    
    let weatherIcon: UIImageView = {
       let theImageView = UIImageView()
       theImageView.translatesAutoresizingMaskIntoConstraints = false
       theImageView.toAutoLayout()
       return theImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addSubview(temperatureLabel)
        view.addSubview(cityLabel)
        view.addSubview(weatherIcon)
        
        setupLayout()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            temperatureLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 16),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.widthAnchor.constraint(equalToConstant: 250),
            
            weatherIcon.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 16),
            weatherIcon.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 20),
        ])
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
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
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
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
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
